##
# Incoming mail processing works like this.
# * A candidate applies to one of our jobs in linkedin.
# * Confirmation email is sent to our email account (tobuforefront@gmail.com).
# * From there, it is forwarded to Cloudmailin's email (5142611706c9ed915a34@cloudmailin.net) using gmail fileters mechanism.
# * Cloudmailin converts the email to HTTP post to /incoming_mails.
# * In the /incoming_mails/new handler, the email email plain content and resume are processed into a new IncomingMail
# instance, Submission and, if person with email address doesn't exist, a new Person.
# * If person (aka candidate) is deterined to be top 20 percent, email s

module Webhook
  class IncomingMailsController < ApplicationController
    include IncomingMailsHelper
    rescue_from ActionController::BadRequest, with: :render_bad_request!
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record!

    skip_before_action :verify_authenticity_token, raise: false
    before_action :auth_incoming_mail, only: [:create]

    # /webhook/incoming_mails
    def create
      logger.info "+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_+++++++_"
        email_processor = Parser::EmailProcessor.new(subject: incoming_mail_params[:subject], attachment: incoming_mail_params[:attachment], email_plain_text: incoming_mail_params[:plain])
        if email_processor.process?
          incoming_mail = build_incoming_mail(email_processor)
          if incoming_mail.save!
            incoming_mail.update_columns(attachment_url: incoming_mail.attachment.service_url || '') if incoming_mail.attachment.attached?
              person_exists!(attrs: build_person_attrs(incoming_mail)) do |person|
                find_or_create_submission(person_id: person.id, contract_job_id: incoming_mail.parsed_job_id, incoming_mail_id: incoming_mail.id)
              end 
            render json: {message: 'success'}, status: 200 and return
          end
        end
        render json: {message: 'Unprocessable entity or unknown request source'}, status: 422
    end

    private

    def incoming_mail_params
      {
        from:             extract_email_from_str(params['headers']['from']),
        to:               extract_email_from_str(params['headers']['to']),
        subject:          params['headers']['subject'],
        plain:            params['plain'],
        date:             params['headers']['date'],
        request_id:       params[:headers][:message_id].gsub('<', '').gsub('>', ''), #for debugging only
        reply:            params['reply_plain'],
        remote_ip:        params['envelope']['remote_ip'],
        attachment:       params['attachments'][0], # expecting single attachment
        parsed_mail_json: '',
        resume_text:      '',
        candidate_email:  '',
        attachment_url:   '',
        parsed_job_id:     0
      }
    end

    def build_incoming_mail email_processor
      attrs = incoming_mail_params.merge(
        {
          resume_text:      email_processor.resume_text,
          candidate_email:  email_processor.candidate_email,
          parsed_mail_json: email_processor.parsed_email_json ,
          parsed_job_id:    email_processor.linkedin_job_id,
          source:           email_processor.source,
          candidate_name:   email_processor.candidate_name
        } 
      )
      IncomingMail.new(attrs)
    end

    def auth_incoming_mail
      unless params[:envelope][:to] == ENV['CLOUDMAIL_ADDRESS'] && params['attachments'].present?
        raise ActionController::BadRequest.new('Not authorized')
      end
    end

    def person_exists!(attrs: {})
      person = Person.find_by(email_address: attrs[:email_address])
      if person.nil?
        if person = Person.create!(attrs)
          yield person
        end
      end
      yield person
    end

    def find_or_create_submission(args)
      Rails.logger.info '++++++++++++++++++++++++ making a submission+++++++++++++++++++++++++++'
      unless Submission.exists?(incoming_mail_id: args[:incoming_mail_id], person_id: args[:person_id])
        job = Job.find_by(linkedin_job_id: args[:contract_job_id])
        raise ActionController::BadRequest, "no job found with linkedin contract id #{args[:contract_job_id]}" if job.nil?
        submission = Submission.create!(
          job_id: job.id, 
          person_id: args[:person_id],
          incoming_mail_id: args[:incoming_mail_id],
          is_linkedin: true
        )
        StageTransition.create(feedback: "applicant", submission_id: submission.id, stage: 'applicant') if submission.present?
        return
      end
      Rails.logger.info "++++ this candidate already applied for linkedin job #{args[:contract_job_id]} +++"
    end

    def build_person_attrs(incoming_mail)
      {
        first_name: incoming_mail.candidate_name.split(' ')[0] ,
        last_name: incoming_mail.candidate_name.split(' ')[1] ,
        email_address: incoming_mail.candidate_email || 'red@flag.com',
        skills: '',
      }
    end

    def render_invalid_record!
      return render json: {message: 'success'}, status: 422
    end

  end
end


# sample curl
# 200
# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: d95114cf-96ff-4a02-a028-70d598071139' -H 'x-forwarded-for: 3.81.103.38' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 0' -H 'x-request-start: 1631928809335' -H 'total-route-time: 0' -H 'content-length: 106725' --data-binary @98ff1499526148cb.raw --request POST https://web.normanisagoodboy.com/webhook/incoming_mails
# curl -H 'host: localhost:3000' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: d95114cf-96ff-4a02-a028-70d598071139' -H 'x-forwarded-for: 3.81.103.38' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 0' -H 'x-request-start: 1631928809335' -H 'total-route-time: 0' -H 'content-length: 106725' --data-binary @98ff1499526148cb.raw --request POST http://localhost:3000/webhook/incoming_mails

# Passed but email not extract
# curl -H 'host: localhost:3000' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 69ca554f-9c78-404f-a17e-5ac4f57e5f5b' -H 'x-forwarded-for: 34.207.184.97' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 2' -H 'x-request-start: 1627917009520' -H 'total-route-time: 0' -H 'content-length: 72930' --data-binary @70871a66148cb0ed.raw --request POST http://localhost:3000/webhook/incoming_mails

# for quring staging host
#
# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 088f65a8-3c7e-44f7-9404-edc6131df6e6' -H 'x-forwarded-for: 54.198.71.131' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 1' -H 'x-request-start: 1626073178881' -H 'total-route-time: 0' -H 'content-length: 57833' --data-binary @986473448cb0edfa.raw --request POST https://qa.euro.normanisagoodboy.com/webhook/incoming_mails
#
# for localhost
#
# curl -H 'host: localhost:3000' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 088f65a8-3c7e-44f7-9404-edc6131df6e6' -H 'x-forwarded-for: 54.198.71.131' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 1' -H 'x-request-start: 1626073178881' -H 'total-route-time: 0' -H 'content-length: 57833' --data-binary @986473448cb0edfa.raw --request POST http://localhost:3000/webhook/incoming_mails

# 500 error issue
# curl 
#
# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 51700f1e-9783-4b3d-b760-e3711379cb89' -H 'x-forwarded-for: 52.55.93.55' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 1' -H 'x-request-start: 1626933923463' -H 'total-route-time: 0' -H 'content-length: 75036' --data-binary @edf7db7739526148.raw --request POST https://www.cardinaltalent.ai/webhook/incoming_mails
#
# for localhost
# 
# curl -H 'host: localhost:300' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 51700f1e-9783-4b3d-b760-e3711379cb89' -H 'x-forwarded-for: 52.55.93.55' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 1' -H 'x-request-start: 1626933923463' -H 'total-route-time: 0' -H 'content-length: 75036' --data-binary @edf7db7739526148.raw --request POST http://localhost:3000/webhook/incoming_mails

# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 51700f1e-9783-4b3d-b760-e3711379cb89' -H 'x-forwarded-for: 52.55.93.55' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 1' -H 'x-request-start: 1626933923463' -H 'total-route-time: 0' -H 'content-length: 75036' --data-binary @edf7db7739526148.raw --request POST https://qa.euro.normanisagoodboy.com/webhook/incoming_mails


# this request not meant to fail but failed with 500 error code 
# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: c250569a-7768-496b-9774-52c6df72a12d' -H 'x-forwarded-for: 54.196.236.181' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 2' -H 'x-request-start: 1626959374701' -H 'total-route-time: 0' -H 'content-length: 69121' --data-binary @23b408ffa7395261.raw --request POST https://qa.euro.normanisagoodboy.com/webhook/incoming_mails
#
# localhost
# 
# curl -H 'host: localhost:3000' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: c250569a-7768-496b-9774-52c6df72a12d' -H 'x-forwarded-for: 54.196.236.181' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 2' -H 'x-request-start: 1626959374701' -H 'total-route-time: 0' -H 'content-length: 69121' --data-binary @23b408ffa7395261.raw --request POST http://localhost:3000/webhook/incoming_mails


# file_converter = Parser::FileConverter.new(attached_resume: params['attachments'][0])
# file_converter.file_2_text
# resume_text = file_converter.resume_text

# incoming_mail = IncomingMail.create_mail params
# incoming_mail.update_columns(attachment_url: incoming_mail.attachment.service_url || '') if incoming_mail.attachment.attached?
# ConversationOrchestrator.respond_to incoming_mail


# 422 custom email with attacment failed . 
# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: e18f2eb4-b9ea-43e0-8e2b-5e15434d1468' -H 'x-forwarded-for: 54.236.112.153' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 0' -H 'x-request-start: 1627393115583' -H 'total-route-time: 0' -H 'content-length: 69065' --data-binary @c3fa4988cb0edfa7.raw --request POST https://qa.euro.normanisagoodboy.com/webhook/incoming_mails
# curl -H 'host: localhost:3000' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: e18f2eb4-b9ea-43e0-8e2b-5e15434d1468' -H 'x-forwarded-for: 54.236.112.153' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 0' -H 'x-request-start: 1627393115583' -H 'total-route-time: 0' -H 'content-length: 69065' --data-binary @c3fa4988cb0edfa7.raw --request POST http://localhost:3000/webhook/incoming_mails


# 200
# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: d1cb8b77-3e66-4979-97d1-7f3692b3e332' -H 'x-forwarded-for: 52.201.250.250' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 0' -H 'x-request-start: 1631709929414' -H 'total-route-time: 0' -H 'content-length: 166528' --data-binary @99360288cb0edfa7.raw --request POST https://cardinaltalent.ai/webhook/incoming_mails
# curl -H 'host: localhost:3000' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: d1cb8b77-3e66-4979-97d1-7f3692b3e332' -H 'x-forwarded-for: 52.201.250.250' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 0' -H 'x-request-start: 1631709929414' -H 'total-route-time: 0' -H 'content-length: 166528' --data-binary @99360288cb0edfa7.raw --request POST http://localhost:3000/webhook/incoming_mails


# 500
# curl -H 'host: 342a3a91.proxy.webhookapp.com' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 5e4b295b-ccda-4b24-a6e6-e2c8139d1857' -H 'x-forwarded-for: 54.205.157.85' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 1' -H 'x-request-start: 1631719660735' -H 'total-route-time: 0' -H 'content-length: 59828' --data-binary @e64ae6ccb0edfa73.raw --request POST https://cardinaltalent.ai/webhook/incoming_mails
# curl -H 'host: localhost:3000' -H 'connection: close' -H 'user-agent: CloudMailin Server' -H 'content-type: multipart/form-data; boundary=----cloudmailinboundry' -H 'accept-encoding: gzip, compressed' -H 'x-request-id: 5e4b295b-ccda-4b24-a6e6-e2c8139d1857' -H 'x-forwarded-for: 54.205.157.85' -H 'x-forwarded-proto: https' -H 'x-forwarded-port: 443' -H 'via: 1.1 vegur' -H 'connect-time: 1' -H 'x-request-start: 1631719660735' -H 'total-route-time: 0' -H 'content-length: 59828' --data-binary @e64ae6ccb0edfa73.raw --request POST http://localhost:3000/webhook/incoming_mails