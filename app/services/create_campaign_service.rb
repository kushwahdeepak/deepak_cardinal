class CreateCampaignService
  attr_reader :campaign, :subject, :cannot_be_contacted_list

  EMAIL_TYPE_CAMPAIGN = 'campaign'.freeze
  DAY_INTERVAL = 14
  def initialize(list_of_recipient_ids, campaign_params, email_credential_params)
    @list_of_recipient_ids = list_of_recipient_ids
    @email_credential_params = email_credential_params
    @campaign_params       = campaign_params
    @campaign_attachment = @campaign_params.delete(:attachment)
    @campaign_attachment_name = @campaign_params.delete(:attachment_name)
    @cannot_be_contacted_list = []
  end

  def call
    @campaign = Campaign.create!(@campaign_params)
    recepients.each do |recipient|
      if recipient && can_recipient_be_contacted?(recipient.id, @campaign)
        CampaignRecipient.create(
          campaign_id: campaign.id, recipient_id: recipient.id,
          contact_recipient_at: DateTime.current, organization_id: @campaign.user.organization.id
        )
        result = OutgoingMailService.send_email_params(campaign_letter_params(recipient))
        Rails.logger.info { result }
      else
        Rails.logger.info "#{recipient.name} has already been contacted recently"
        @cannot_be_contacted_list << recipient.email_address
      end
    end
  end

  private

  def recepients
    @recepients ||= Person.where(id: @list_of_recipient_ids)
  end

  def can_recipient_be_contacted? recipient_id, campaign
    last_contacted_recipient = CampaignRecipient.where(
      organization_id: campaign.user.organization.id,
      recipient_id: recipient_id
     ).order(contact_recipient_at: :desc).first
     return true if last_contacted_recipient.nil?
     return (Date.today - last_contacted_recipient.contact_recipient_at.to_date).to_i > DAY_INTERVAL
  end

  def campaign_letter_params(recipient)
    {
      email_type: EMAIL_TYPE_CAMPAIGN,
      content: customize_subject_and_content(recipient),
      subject: subject,
      sender_email: campaign[:source_address],
      recipient_email: recipient[:email_address],
      campaign_data: {
        campaign_id: campaign.id,
        recipient_id: recipient.id
      },
      email_credentials: @email_credential_params,
      organization_id: @campaign.user.organization.id,
      attachment: @campaign_attachment&.tempfile,
      attachment_name: @campaign_attachment_name
    }
  end

  def customize_subject_and_content(recipient)
    first_name = recipient&.first_name.present? ? recipient.first_name : ''
    last_name = recipient&.last_name.present? ? recipient.last_name : ''
    campaign_content = campaign[:content].gsub('{{first_name}}', first_name).gsub('{{last_name}}', last_name)
    @subject = campaign[:subject].gsub('{{first_name}}', first_name).gsub('{{last_name}}', last_name)
    # OutgoingEmailsHelper.inject_unsubscribe_link_in_campaign(campaign_content, recipient.id, @campaign.user_id)
    campaign_content
  end
end
