class ImportJob < ApplicationRecord
  has_one_attached :job_file

  STATUS_NOT_DONE = 'not done'
  STATUS_IN_PROGRESS = 'being processed'
  STATUS_FAILED = 'failed'
  STATUS_DONE = 'complete'
  belongs_to :creator,
    class_name: "User",
    foreign_key: "user_id"

  def intake
    logit 'd', "initiated by user #{creator.id}", true
    update(status: STATUS_IN_PROGRESS)
    begin
      iterate_input_rows
    rescue StandardError => e #this can happen if we fail to load the .csv file or something
      self.status = STATUS_FAILED
      logit'e',"Batch failed due to an unexpected error: #{e.full_message}.", true
      raise e
    else
      self.status = STATUS_DONE
      logit'd', "batch run finished OK.", true
    ensure
      save!
    end #ensure
  end #method

  def iterate_input_rows
    content = self.job_file.download
    count = content.gsub("\r", "\n").split("\n").size
    logit 'd', "loaded file with #{count} rows."
    CSV.parse(content, headers: true, skip_blanks: true, converters: :date, skip_lines: /^(?:,\s*)+$/, encoding: 'windows-1251:utf-8') do |row|
      params = row.to_hash.transform_keys{ |key| key.to_s.downcase.to_sym }.compact
      intake_single params, creator
    end
  end

  def intake_single params, creator
    job = nil
    params[:user] = creator
    params[:portalcompanyname] = self&.company_name
    params[:organization_id] = self&.organization_id 
    params[:notificationemails] = self&.notificationemails
    begin
      logit 'd', "intaking a jobs with #{params}", true
      job = Job.create params
      GenerateScoresJob.perform_later({ job_id: job.id })
      job
    rescue StandardError => e
      logit 'e', "redcord rejected because: #{e.message}.", true
      logit 'd', e.full_message
    else
      logit 'd', "record created ok. id=#{job.id}", true
    end
    job
  end

  def load_file
    content = self.original_file.download
    count = content.gsub("\r","\n").split("\n").size
    logit 'd', "loaded file with #{count} rows."
    CSV.new content, {
      headers: true,
      skip_blanks: true,
      converters: :date,
      skip_lines: /^(?:,\s*)+$/,
      encoding: 'windows-1251:utf-8'
    }
  end
  # assumes there is only one worker dyno that can finish all the work before the
  # next iteration. This is very volnerable to race conditions if more than one dyno,

  def self.intake_all_not_done
    not_dones = ImportJob.where('status=?', ImportJob::STATUS_NOT_DONE)
    logger.debug "Importing #{not_dones.size} of not-done batches."
    not_dones.each do |batch|
      batch.intake
    end
    #todo: failed reporting and a way to change from failed to closed after failure
    # is investigated
  end
  def logit level, message, save_to_batchs_log = false
    case level
      when 'd'
        logger.tagged("Import Job:#{self.id}") { logger.debug message }
      when 'w'
        logger.tagged("Import Job:#{self.id}") { logger.warn message }
      when 'e'
        logger.tagged("Import Job:#{self.id}") { logger.error message }
    end
    message =  Time.new.to_s + " " + message.gsub("\n","")
    self.log = (self.log.present?) ? (self.log + "\n" + message) : (message) if save_to_batchs_log
  end

  def user_message
    hash = { #todo: make this the status defenition
      STATUS_NOT_DONE => 'Import Job is in queue.',
      STATUS_IN_PROGRESS => 'Import Job is in progress',
      STATUS_FAILED => "Import Job failed for unknown reason.  Some records mabe not processed.  Of those processed,  #{ok_count} records created.  #{err_count} failed.",
      STATUS_DONE => "Import Job was completed.  #{ok_count} records created.  #{err_count} failed."
    }
    hash[status]
  end
end
