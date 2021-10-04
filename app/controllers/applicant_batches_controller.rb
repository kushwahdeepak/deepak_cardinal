class ApplicantBatchesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  # POST /applicants
  def create
    applicant_batch_params[:applicant_files]&.each do |file|
      applicant_batch = ApplicantBatch.new({ user_id: current_user&.id, job_id: applicant_batch_params[:job_id], organization_id: applicant_batch_params[:orgainization_id], applicant_file: file })
      applicant_batch.model_klass = 'Person'
      return render json: {messages: 'File upload failed' } unless applicant_batch.save
    end
    render json: {message: 'Success' }
  end

  private
  
  def applicant_batch_params 
    params.require(:applicant_batch).permit( :job_id, :orgainization_id, :current_user_id, { applicant_files: [] })
  end
end

