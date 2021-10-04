require 'csv'
module ApplicantBatchUpload
  extend ActiveSupport::Concern

  #  belongs_to :creator,
  #  class_name: "User",
  #  foreign_key: "user_id"
  class_methods do
    def applicant_all_not_done
      not_dones = ApplicantBatch.where('status=?', ApplicantBatch::STATUS_NOT_DONE)
      logger.debug "Importing #{not_dones.size} of not-done batches."
      not_dones.each do |batch|
        batch.applicant
      end
    end
  end

  def applicant
    update(status: ApplicantBatch::STATUS_IN_PROGRESS)
    begin
      iterate_input_rows
    rescue StandardError => e #this can happen if we fail to load the .csv file or something
      self.status = ApplicantBatch::STATUS_FAILED
      logit'e',"Batch failed due to an unexpected error: #{e.full_message}.", true
      raise e
    else
      self.status = ApplicantBatch::STATUS_DONE
      logit'd', "batch run finished OK. created #{ok_count} candidates.  failed to create #{err_count}", true
    ensure
      save!
    end #ensure
  end #method

  def iterate_input_rows
    content = self.applicant_file.download
    count = content.gsub("\r", "\n").split("\n").size
    logit 'd', "loaded file with #{count} rows."
    CSV.parse(content, headers: true, skip_blanks: true, converters: :date, skip_lines: /^(?:,\s*)+$/) do |row|
      params = row.to_hash.transform_keys{ |key| key.to_s.downcase.to_sym }.compact
      applicant_single model_klass, params
    end
  end

  def applicant_single model_klass_str, params
    model_klass = Object.const_get model_klass_str
    model_inst = nil
    # params[:user_id] = creator
    params[:user_id] = self.user_id
    params[:organization_id] = self.organization_id
    begin
      logit 'd', "intaking a #{model_klass.name} with #{params}", true
      model_inst = model_klass.create! params
      create_submission(model_inst.id, params[:user_id]) if self.job_id.present?
      GenerateScoresService.new({person_id: model_inst.id}).call if model_klass_str == 'Person'
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

  def create_submission(person_id, user_id)
    submission = Submission.create!(person_id: person_id, job_id: self.job_id, user_id: user_id)
    StageTransition.create!(feedback: "test", stage: "lead", submission_id: submission.id)
  end
end
