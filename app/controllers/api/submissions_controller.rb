require 'date'

class Api::SubmissionsController < Api::BaseController
    def get_metrics
      date_range = DateTime.parse(params[:start])..DateTime.parse(params[:end])
      all_metrics = date_range.map{ |date| submission_metrics_for date }

      render json: all_metrics, status: 200
    end

    def mails_missing_submission
      date = DateTime.parse(params[:date])

      mails_missing_submission = get_mails_missing_submission(date)

      render json: mails_missing_submission, status: 200
    end

    def submission_metrics_for date
      incoming_mail = IncomingMail.where(["public.incoming_mails.created_at >= ? AND public.incoming_mails.created_at <= ? AND public.incoming_mails.from = ?", date.beginning_of_day, date.end_of_day,ENV.fetch("INCOMING_GATEWAY_ADDRESS")])
      submissions = Submission.where(["submissions.created_at >= ? AND submissions.created_at <= ?", date.beginning_of_day, date.end_of_day])
      
      # Mails with submission creation failures
      mails_missing_submission = incoming_mail - incoming_mail.joins(:submission)   
      
      mails_missing_job = incoming_mail.where(parsed_job_id: 0)
      mails_missing_email = incoming_mail.where(candidate_email: [nil,''])
      mails_missing_email_percentage = (mails_missing_email.count.to_f/incoming_mail.count) *  100
      # We only want submissions created by incoming mails
      incoming_mail_submissions = submissions.where.not(incoming_mail_id: nil)
     
      created_people = Person.where(["public.people.created_at >= ? AND public.people.created_at <= ?", date.beginning_of_day, date.end_of_day])
      mail_created_people = created_people.joins('INNER JOIN submissions ON submissions.incoming_mail_id = people.incoming_mail_id')

      metrics = {
        date: date.to_datetime,
        submission_creations: incoming_mail_submissions.count,
        person_creations: mail_created_people.count,
        mails_missing_job: mails_missing_job.count,
        mails_missing_email: mails_missing_email.count,
        mails_missing_submission: mails_missing_submission.count,
        total_mails: incoming_mail.count,
        percentage: mails_missing_email_percentage
      }
    end

    private

    def get_mails_missing_submission date
      incoming_mail = IncomingMail.where(["public.incoming_mails.created_at >= ? AND public.incoming_mails.created_at <= ?", date.beginning_of_day, date.end_of_day])

      incoming_mail - incoming_mail.joins(:submission)      
    end
end
