class WebhooksController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:receive_candidate_hired, :receive_candidate_stage_change, :receive_candidate_archive_state_change]
  skip_before_action :verify_authenticity_token

  def receive_candidate_hired
    require 'date'

    token = payload_params['webhook']['token']
    trigger_time = payload_params['webhook']['triggeredAt']

    validate_webhook(token, trigger_time)

    person = Person.new
    person.lever_candidate_id = payload_params['webhook']['data']['candidateId']
    person.save!(validate: false)

    render nothing: true
  end

  def receive_candidate_stage_change
    require 'date'

    token = payload_params['webhook']['token']
    trigger_time = payload_params['webhook']['triggeredAt']

    validate_webhook(token, trigger_time)

    person = Person.new
    person.lever_candidate_id = payload_params['webhook']['data']['candidateId']
    person.save!(validate: false)
    # epoch_time = Time.at(payload_params['webhook']['triggeredAt'])
    # previous_stage = person.archive_states.where(lever_id: payload_params['webhook']['data']['fromStageId'], updated_at: epoch_time).first_or_initialize
    # current_stage = person.archive_states.where(lever_id: payload_params['webhook']['data']['toStageId'], updated_at: epoch_time).first_or_initialize
    # previous_stage.save
    # current_stage.save

    render nothing: true
  end

  def receive_candidate_archive_state_change
    require 'date'

    token = payload_params['webhook']['token']
    trigger_time = payload_params['webhook']['triggeredAt']

    validate_webhook(token, trigger_time)

    person = Person.new
    person.lever_candidate_id = payload_params['webhook']['data']['candidateId']
    epoch_time = Time.at(payload_params['webhook']['triggeredAt'])

    person.save!(validate: false)

    if payload_params['webhook']['data']['toArchived'].nil?
      person.active = true
      person.active_date_at = epoch_time
    else
      person.active = false
      person.save!(validate: false)
      previous_archived_time = Time.at(payload_params['webhook']['data']['toArchived']['archivedAt'])
      previous_archive_state = person.archive_states.where(lever_id: payload_params['webhook']['data']['toArchived'], archived_at: previous_archived_time, reason: payload_params['webhook']['data']['toArchived']['reason']).first_or_initialize
      previous_archive_state.save
    end

    if payload_params['webhook']['data']['fromArchived']
      current_archived_time = Time.at(payload_params['webhook']['data']['fromArchived']['archivedAt'])
      current_archive_state = person.archive_states.where(lever_id: payload_params['webhook']['data']['fromArchived'], updated_at: current_archived_time, reason: payload_params['webhook']['data']['fromArchived']['reason']).first_or_initialize
      current_archive_state.save
    end

    person.save!(validate: false)

    render nothing: true
  end

  private

  def payload_params
    params.permit(
      :id,
      :triggeredAt,
      :event,
      { :data => [
          :candidateId
        ]
      },
      :signature,
      :token,
      {
        :webhook => [
          :id,
          :triggeredAt,
          :event,
          {
            :data => [
              :candidateId
            ]
          },
          :signature,
          :token
        ]
      }
    )
  end

  def validate_webhook(token, trigger_time)
   plain_text = payload_params['webhook']['token'] + payload_params['webhook']['triggeredAt'].to_s
   signature_token = ENV.fetch('LEVER_SIGNATURE_TOKEN')

   mac = OpenSSL::HMAC.hexdigest("SHA256", signature_token, plain_text)
   # hash = crypto.createHmac('sha256', signature_token)
   # hash.update(plain_text)
   # hash = hash.digext('hex')
   return payload_params['webhook']['signature'] == mac
  end
end
