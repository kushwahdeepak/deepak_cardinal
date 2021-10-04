class CampaignsController < ApplicationController
  def index
    @campaigns = Campaign.all
  end

  def show
    @campaign_recipients = CampaignRecipient.where(campaign_id: params[:id])
  end

  def update_recipient_mail_status
    @campaign_recipient = CampaignRecipient.find_by(campaign_id: params[:campaign_id], recipient_id: params[:recipient_id])
    @campaign_recipient.update(status: :sent)
    head :no_content
  end

  def create
    list_of_recipient_ids = params[:list_of_recipient_ids]
    logger.info "+++++++++++++++++++++++++++++++++++++++++"
    logger.info email_credential_params
    result = CreateCampaignService.new(list_of_recipient_ids, campaign_params, email_credential_params)
    result.call
    render json: result.cannot_be_contacted_list, status: 201
  end

  private

  def campaign_params
    params.require(:campaign).permit(
      :source_address,
      :subject,
      :content,
      :job_id,
      :user_id,
      :attachment,
      :attachment_name
    )
  end
  def email_credential_params
    params.require(:email_credentials).permit(:email_address, :password)
  end
end
