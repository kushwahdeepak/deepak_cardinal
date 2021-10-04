class IntakeBatch < ApplicationRecord
  STATUS_NOT_DONE = 'not done'
  STATUS_IN_PROGRESS = 'being processed'
  STATUS_FAILED = 'failed'
  STATUS_DONE = 'complete'
  has_one_attached :original_file
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
      logit'd', "batch run finished OK. created #{ok_count} candidates.  failed to create #{err_count}", true
    ensure
      save!
    end #ensure
  end #method

  def iterate_input_rows
    content = self.original_file.download
    count = content.gsub("\r", "\n").split("\n").size
    logit 'd', "loaded file with #{count} rows."
    CSV.parse(content, headers: true, skip_blanks: true, converters: :date, skip_lines: /^(?:,\s*)+$/, encoding: 'windows-1251:utf-8') do |row|
      params = row.to_hash.transform_keys{ |key| key.to_s.downcase.to_sym }.compact
      intake_single model_klass, params, creator
    end
  end

  def intake_single model_klass_str, params, creator
    model_klass = Object.const_get model_klass_str
    model_inst = nil
    params[:user] = creator
    params[:intake_batch] = self
    begin
      logit 'd', "intaking a #{model_klass.name} with #{params}", true
      model_inst = model_klass.create params
      model_inst
    rescue StandardError => e
      logit 'e', "redcord rejected because: #{e.message}.", true
      logit 'd', e.full_message
      self.err_count += 1
    else
      logit 'd', "record created ok. id=#{model_inst.id}", true
      self.ok_count += 1
    end
    model_inst
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
    not_dones = IntakeBatch.where('status=?', IntakeBatch::STATUS_NOT_DONE)
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
        logger.tagged("batch:#{self.id}") { logger.debug message }
      when 'w'
        logger.tagged("batch:#{self.id}") { logger.warn message }
      when 'e'
        logger.tagged("batch:#{self.id}") { logger.error message }
    end
    message =  Time.new.to_s + " " + message.gsub("\n","")
    self.log = (self.log.present?) ? (self.log + "\n" + message) : (message) if save_to_batchs_log
  end

  def user_message
    hash = { #todo: make this the status defenition
      STATUS_NOT_DONE => 'Batch is in queue.',
      STATUS_IN_PROGRESS => 'Batch is in progress',
      STATUS_FAILED => "Batch failed for unknown reason.  Some records mabe not processed.  Of those processed,  #{ok_count} records created.  #{err_count} failed.",
      STATUS_DONE => "Batch was completed.  #{ok_count} records created.  #{err_count} failed."
    }
    hash[status]
  end
end
