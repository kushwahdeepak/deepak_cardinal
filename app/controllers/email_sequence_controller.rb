class EmailSequenceController < ApplicationController
  rescue_from  ActiveRecord::RecordInvalid, with: :render_error

  def show
    email_sequences = EmailSequence.where(job_id: params[:job_id])
    if email_sequences.present?
      render json: { found: true, mail: email_sequences }
    else
      render json: {found: false}
    end
  end

  def create
    email = EmailSequence.new(email_sequence_params)
      if email.save
        return render json: { mail: email, success: true, messageType: 'success', msg: 'Uploaded Successfully' }
      end

    render json: { success: false, messageType: 'failure', msg: 'Failed to Uplaod' }
  end

  def update
    if email = EmailSequence.find_by(id: params[:id], sequence: email_sequence_params[:sequence])
      email.update!(email_sequence_params)
      render json: { mail: email, success: true, messageType: 'success', msg: 'Updated successfully' }
      return
    end
    render json: { success: false, messageType: 'failure', msg: 'Create before updating' }
  end

  def bulk_upload
    csv_files = params[:applicant_batch][:candidate_files]
    email_sequence_id = params[:email_sequence_id]
    if csv_files.present?
      begin
        csv_files.each do |csv_file|
          UploadEmailSequenceCandidates.new(csv_file.path, email_sequence_id).file_import
        end
      rescue
        render json: { success: false, messageType: 'failure', msg: 'Somthing went wrong' }
        return
      end
      render json: { success: true, messageType: 'success', msg: 'Uploaded successfully' }
    end
  end

 private
 
  def email_sequence_params
    params.require(:email_sequence).permit(:subject, :email_body, :sent_at, :job_id, :sequence)
  end

  def render_error
    render json: { success: false, messageType: 'failure', msg: 'Failed to Update' } and return 
  end
end
