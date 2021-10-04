module OutgoingEmailsHelper
  class << self
    include Rails.application.routes.url_helpers
  end

  def self.candidate_interested employer_name, candidate_name, submission_id, reply
    <<~HEREDOC
      Hi #{employer_name},<br>
      Would you like to speak with the attached candidate, #{candidate_name}?
      ( <a href='#{ENV['HOST']}/incoming_mails/employer_response?submission_id=#{submission_id}&answer=yes'>Yes</a>
      or
      <a href='#{ENV['HOST']}/incoming_mails/employer_response?submission_id=#{submission_id}&answer=no'>No</a> )

      Listed below are the candidate's responses to the questionnaire<br><br>
      #{reply&.split("\n")&.map{|line| line + "<br>"}&.join}
      <br><br>

      Cheers,<br>

      Olivia  
    HEREDOC
  end

  def self.employer_interested(candidate_name, calendly_link)
    <<~HEREDOC
      Hi #{candidate_name},<br><br>

      We would like to schedule an interview with you to learn about your experiences and tell you more about the role!<br><br>

      Please sign up for a time here to speak with our hiring manager: <a href=#{calendly_link}>Calendly link</a><br><br>

      We look forward to speaking with you.<br><br>

      Cheers,<br><br>

      Olivia
    HEREDOC
  end

  def self.top_20_greeting candidate_name, job_name, company_name
    <<~HEREDOC
      <p>Hi #{candidate_name},
      <p>Thank you for applying for the position of #{job_name}.  The name of the company is #{company_name}.  Can you let me know your answers to the following questions:
      <p>
      1) What is your availability for a phone interview?<br>
      2) What is your base salary expectation?<br>
      3) What are your top 5 technologies that you have experience with?<br>
      4) What is your employment authorization?  (US Citizen, Green Card, H1B, etc.)<br>

      <p>I look forward to moving forward as soon as we receive your response!  Please also attach your current resume.

      <p>Sincerely,

      <p>#{ENV.fetch('OUTGOING_EMAIL_USERNAME')}
    HEREDOC
  end

  def self.inviting_user inviting_user_name, invited_user_name, organization_name, invitation_id
    <<~HEREDOC
      Hi #{invited_user_name},<br>
      #{inviting_user_name} is inviting you in #{organization_name} organization.
      Would you like to accept this invitation?
      ( <a href='#{ENV['HOST']}/incoming_mails/invitation_process?invitation_id=#{invitation_id}&answer=yes'>Yes</a>
      or
      <a href='#{ENV['HOST']}/incoming_mails/invitation_process?invitation_id=#{invitation_id}&answer=no'>No</a> )

      <br><br>

      Cheers,<br>

      The Cardinal Talent Team
    HEREDOC
  end

  def self.inject_unsubscribe_link_in_campaign(content, person_id, user_id)
    content << "<br><br><a href=#{unsubscribe_blacklists_url(person_id: person_id, user_id: user_id)}>Unsubscribe</a>"
    content
  end

  def self.email_confirmation user
    <<~HEREDOC
      <br />
      Hello #{user.first_name},<br />
      Thank you for creating your account with us at Cardinal Talent! <br />
      Please verify your email by clicking on the link below: <br />
      <a href="#{confirm_email_user_url(user.confirm_token)}">
        #{confirm_email_user_url(user.confirm_token)}
      </a>
      <br />
        We look forward to working with you!
      <br />
      <div style="display: inline-flex; margin-top: 10px;">
        <img src="https://ci6.googleusercontent.com/proxy/3OIAY66DCdoUNJFDLNhD8nbAuH2axA34q75_HdSTruuIbqQiCBaY7guhlJ4z_mWBd0I0k1D1S_YcxMeSEWjuAcMqoaNzI6NCnjk=s0-d-e1-ft#https://marketplace-ch.s3.amazonaws.com/header-logo.png" alt="" style="max-width: 120px;">
      </div>  
      <div style=" margin-top: 5px;">
        Cheers,<br /> 
        Customer Support at Cardinal Talent
      </div>
    HEREDOC
  end

  def self.inviting_candidate(candidate_full_name, job_title, interview_date, interview_time, organization_name, job_id, organization_id)
    <<~HEREDOC
      <p> Hi #{candidate_full_name},
      <p>
        As discussed, you have an interview on #{interview_date} <br>
        Please be available on time before the interview to avoid any issues.
      <p>
        Job Profile: <a href='#{ENV['HOST']}/jobs/#{job_id}/#{job_title}'>#{job_title}</a> <br>
        Time: #{interview_time} <br>
        Company Name: <a href='#{ENV['HOST']}/organizations/#{organization_id}/careers'>#{organization_name}</a> <br>

      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.inviting_recruiter(recruiter_fullname, candidate_full_name, job_title, interview_date, interview_time, organization_name, job_id, organization_id)
    <<~HEREDOC
      <p> Hi #{recruiter_fullname}, <br>
      <p> We have schedule interview with #{candidate_full_name}. <br>
      <p>
        Job Profile: <a href='#{ENV['HOST']}/jobs/#{job_id}/#{job_title}'>#{job_title}</a> <br>
        Date: #{interview_date} <br>
        Time: #{interview_time} <br>
        Company Name: <a href='#{ENV['HOST']}/organizations/#{organization_id}/careers'>#{organization_name}</a> <br>

      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.reschedule_invitation_to_candidate(candidate_full_name, job_title, interview_date, interview_time, organization_name, job_id, organization_id)

    <<~HEREDOC
      <p> Hi #{candidate_full_name},
      <p> This email is to inform you have an interview on #{interview_date} have reschedule.
          Due to some technical difficulties, it will not be possible to conduct the interview on the pre-mentioned time schedule.
      <p> Let me get back to you with a fresh time slot that works for both of us.<br> 
      <p>
        Job Profile: <a href='#{ENV['HOST']}/jobs/#{job_id}/#{job_title}'>#{job_title}</a> <br>
        Time: #{interview_time} <br>
        Company Name: <a href='#{ENV['HOST']}/organizations/#{organization_id}/careers'>#{organization_name}</a> <br>

      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.reschedule_invitation_to_recruiter(recruiter_fullname, candidate_full_name, job_title, interview_date, interview_time, organization_name, job_id, organization_id)
    <<~HEREDOC
      <p> Hi #{recruiter_fullname}, <br>
      <p> This email is to inform you that interview is reschedule with #{candidate_full_name}.
          Due to some technical difficulties, it will not be possible to conduct the interview on the pre-mentioned time schedule.
      <p> Let me get back to you with a fresh time slot that works for both of us.<br>
      <p>
        Job Profile: <a href='#{ENV['HOST']}/jobs/#{job_id}/#{job_title}'>#{job_title}</a> <br>
        Date: #{interview_date} <br>
        Time: #{interview_time} <br>
        Company Name: <a href='#{ENV['HOST']}/organizations/#{organization_id}/careers'>#{organization_name}</a> <br>

      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.cancel_email_for_candidate(candidate_full_name, job_title, interview_date, interview_time, organization_name, job_id, organization_id)
    <<~HEREDOC
      <p> Hi #{candidate_full_name},
      <p> This is to inform you that scheduled interview on  #{interview_date} has been cancelled.
          Due to some technical difficulties, it will not be possible to conduct the interview on the pre-mentioned time schedule. 
      <p>
        Job Profile: <a href='#{ENV['HOST']}/jobs/#{job_id}/#{job_title}'>#{job_title}</a> <br>
        Time: #{interview_time} <br>
        Company Name: <a href='#{ENV['HOST']}/organizations/#{organization_id}/careers'>#{organization_name}</a> <br>

      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.cancel_email_for_recruiter(recruiter_fullname, candidate_full_name, job_title, interview_date, interview_time, organization_name, job_id, organization_id)

    <<~HEREDOC
      <p> Hi #{recruiter_fullname}, <br>
      <p> This is to inform you that scheduled interview with #{candidate_full_name} has been cancelled.
          Due to some technical difficulties, it will not be possible to conduct the interview on the pre-mentioned time schedule.
      <p>
        Job Profile: <a href='#{ENV['HOST']}/jobs/#{job_id}/#{job_title}'>#{job_title}</a> <br>
        Date: #{interview_date} <br>
        Time: #{interview_time} <br>
        Company Name: <a href='#{ENV['HOST']}/organizations/#{organization_id}/careers'>#{organization_name}</a> <br>

      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.invite_to_apply(referral,job,user,url)
    <<~HEREDOC
      <p> Hi #{referral.invitee_name}!, <br>
      <p> #{user.name} invited you to apply to the job #{job.name}!
      <p>
      For Apply,Please Visit: <a href='#{url}'>Apply</a> <br>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.approve_reject_organization(organization,user)
    <<~HEREDOC
      <p> Hi #{user.first_name}!, <br>
      <p>
      Your request to create an organization on CardinalTalent has been  #{organization.status}! <br>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.add_single_candidate_email(job,person,user)
    <<~HEREDOC
      <p> Hi #{user.first_name}
      <p> New candidate  #{person.first_name} added on your job  <a href='#{ENV['HOST']}/jobs/#{job.id}/#{job.name}'>#{job.name}</a>!
      <p>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.email_verify_success(first_name)
      <<~HEREDOC
        <p> Hi #{first_name}, <br>
        <p> Thank you for verify your email address.<br>
        <br>
        Cheers,<br>
        The Cardinal Talent Team
      HEREDOC
  end

  def self.employer_allowed_to_post_job(first_name)
    <<~HEREDOC
      <p> Hi #{first_name}, <br>
      <p> Your account has been active now for job posting.<br>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.employer_pending_to_job_post(first_name)
    <<~HEREDOC
      <p> Hi #{first_name}, <br>
      <p> Start posting jobs now.<br>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.job_post_success(person,job)
    <<~HEREDOC
      <p> Hi #{person.first_name}, <br>
      <p> Your job #{job.name} has been posted and is live. Inform our team to verify the job.<br>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

  def self.job_post_review(person,job)
    <<~HEREDOC
      <p> Hi #{person.first_name}, <br>
      <p> Your job #{job.name} has been posted and is under review. Inform our team to verify the job.<br>
      <br>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end
  
  def self.organization_delete(person,organization_name)
    <<~HEREDOC
      <p> Hi #{person.first_name}, <br>
      <p> Your organization #{organization_name} has been deleted by admin.<br>
      <br>
      <br>
      Cheers,<br>
      The Cardinal Talent Team
    HEREDOC
  end

end
