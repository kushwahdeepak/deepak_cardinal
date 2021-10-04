
# Depricated Code | replace by webhook/incoming_mail_controller
# Need to move used action to other appropriate contollers
# Out of domain code in this controller which don't belongs to this controller

class IncomingMailsController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!, :only => [:index, :show, :new, :invitation_process]

  skip_before_action :verify_authenticity_token

  EMAIL_TYPE_EMPLOYER_INTERESTED = "email_candidate_about_employer_interested"
  OUTGOING_EMAIL_USERNAME = "noreply@cardinaltalent.ai"

  #application noticed from linkedin go to one of these accounts.  From there, they are forwarded to here
  # INCOMING_GATEWAY_EMAILS = [ENV.fetch("INCOMING_GATEWAY_ADDRESS")]

  def parse_plain
    hash = PlainEmailParser.parse params['plain']
    render json: hash.to_json
  end

  def show
    redirect_to "/" unless current_user.role == 'admin'
    @incoming_mail = IncomingMail.find params[:id]
  end
  def new
    redirect_to "/" unless current_user.role == 'admin'
  end

  def index
    redirect_to "/" unless current_user.role == 'admin'
    @incoming_mails = IncomingMail.includes(:submission).with_attached_attachment.paginate(page: params[:page]).order('created_at DESC')
  end

  def print_contents uploaded_file
    f_name = uploaded_file.original_filename
    f_contents = uploaded_file.tempfile.read
    puts f_contents
  end

  def employer_response
    submission = Submission.find(params[:submission_id])
    person     = Person.find(submission.person_id)
    job        = Job.find(submission.job_id)
    employer   = job.user

    subject = "Scheduling an Interview with #{job.portalcompanyname}"
    if employer.calendly_link.present?
      content = OutgoingEmailsHelper.employer_interested(person.first_name, employer.calendly_link)

      if params[:answer] === 'yes'
        params = {
          recipient_email: person.email_address,
          sender_email: OUTGOING_EMAIL_USERNAME,
          subject: subject,
          content: content,
          email_type: EMAIL_TYPE_EMPLOYER_INTERESTED
        }

        OutgoingMailService.send_email_params(params)
        render plain: 'success', status: 200
      end
    else
      logger.info "User #{employer.email} doesn't have calendly link"
      render json: { error: "User #{employer.email} doesn't have calendly link" }, status: 422
    end
  end

  def invitation_process
    invitation = Invitation.find(params[:invitation_id])
    invited_user = invitation.invited_user
    if invitation.status == Invitation::PENDING
      if current_user.id == invited_user.id
        if params[:answer] === 'yes'
          invitation.status = Invitation::ACCEPTED
          invited_user.organization_id = invitation.organization_id
          invited_user.save!
          recruiter_organization(invitation.organization_id, invited_user)
        else
          invitation.status = Invitation::REJECTED
        end
        invitation.save!
        redirect_to "/" 
      else
        logger.info "This invitation is not valid for user #{current_user.email}"
        render json: { error: "This invitation is not valid for user #{current_user.email}" }, status: 422
      end
    else
      render json: {error:  "The inviation is expired"}, status: 422
    end 
  end

  def create
    logger.info "+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_"
    incoming_mail = IncomingMail.create_mail incoming_mail_params
    ConversationOrchestrator.respond_to incoming_mail
    render :plain => 'success', :status => 200
  end


  def incoming_mail_params
    params
    # params.to_unsafe_h.to_h.stringify_keys
    #params.permit(:plain, :html, :headers )
  end

  def recruiter_organization(organization_id, recruiter)
    RecruiterOrganization.create!(organization_id: organization_id, user_id: recruiter&.id, status: RecruiterOrganization::ACCEPTED)
  end
end
