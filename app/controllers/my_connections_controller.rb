class MyConnectionsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:contact]
  before_action :show_received_invitations, only: [:invite]
  before_action :authenticate_user!, except: [:unsubscribe]

  RESULTS_PER_PAGE = 10

  def index
    person = Person.find_by(email_address: current_user.email)
    @avatar_url = person.avatar_url if person.present?
    respond_to do |format|
      format.html {}
      format.json {
        render json: set_contact_request_data(%w(send received accepted))
      }
    end
  end

  def create
    ImportGoogleContactService.new(gmail_permitted_params[:contacts], current_user.id).import if gmail_permitted_params[:contacts].present? && gmail_permitted_params[:source] == "gmail"

    respond_to do |format|
      format.html { redirect_to action: :index}

      format.json {
        render json: set_contact_request_data(%w(send))
      }
    end
  end

  def invite
    contact = Contact.find_by(id: params[:id])

    if contact&.email == current_user.email
      contact.update_columns(target_user_id: current_user.id)
      session.delete(:contact_request_id)
      flash[:notice] = "Successfully verified contact"

    else
      flash[:alert] = "Invalid contact profile"
    end

    redirect_to my_connections_path
  end


  def update_status
    respond_to do |format|
      if contact_params[:status].present? && load_contact(contact_params[:id]).present?
        if @contact.update(status: contact_params[:status])
          format.html {redirect_to action: :index}

          format.json {
            render json: set_contact_request_data(%w(received accepted))
          }

        else
          format.json {render json: {status: 'error', error: "Unable to update contact"} }
        end

      else
        format.html {redirect_to action: :index}
        format.json { render json: {status: 'error', error: "Invalid request data"} }
      end
    end
  end

  # TODO
  # Move to separte controller
  def unsubscribe
    if contact_params[:email].present?
      unsubscribe = Unsubscribe.find_by(email: contact_params[:email])
      if unsubscribe.nil?
        Unsubscribe.create!(email: contact_params[:email])
        redirect_to root_path, notice: "You’ve unsubscribed"
      else
        redirect_to root_path, notice: "You’ve already unsubscribed"
      end
    end
  end

  private

  def contact_params
    params.permit(:email, :status, :id, :sent_contacts_page, :received_contacts_page, :accepted_contacts_page)
  end

  def gmail_permitted_params
    params.require(:my_connection).permit(:source, :contacts => [:first_name, :last_name, :dob, :job_title, phone: [:number], email: [:address], address: [:formatted, :street, :city, :region, :country, :postal_code]])
  end

  def load_contact(id)
    @contact = Contact.find_by(id: id)
  end

  def show_received_invitations
    if session[:contact_request_id].blank? && current_user.blank?
      session[:contact_request_id] = params[:id]
    end
  end

  def set_contact_request_data(contact_requests)
    invitations_data = {status: 'success'}

    contact_requests.each do |get|
      contacts = Contact.send("#{get}_contact_requests".to_sym, current_user.id)
                                .paginate(page: send("#{get}_contacts_page_params".to_sym), per_page: RESULTS_PER_PAGE)
                                .includes(:user).order(created_at: :desc)

      invitations_data.merge!({
        "#{get}_contact_requests".to_sym => contacts.as_json,
        "#{get}_contact_total_count".to_sym => contacts.total_entries,
        "#{get}_contact_total_page".to_sym => contacts.total_pages
      })
    end
    invitations_data
  end


  def send_contacts_page_params
    [contact_params[:sent_contacts_page].to_i, 1].max
  end

  def received_contacts_page_params
    [contact_params[:received_contacts_page].to_i, 1].max
  end

  def accepted_contacts_page_params
    [contact_params[:accepted_contacts_page].to_i, 1].max
  end

end
