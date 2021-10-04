require 'open-uri'

class MatchScoreByResume
  include IncomingMailsHelper

  attr_reader :email

  def initialize(resume: nil, current_user: nil)
    @resume = resume
    @current_user = current_user
  end

  def call
    initialize_person
    generate_scores
  end

  private

  def initialize_person
    if @current_user.present?
      update_person
    else
      create_person_from_resume
    end
  end

  def update_person
    @person = Person.find_or_create_by(email_address: @current_user.email)
    @email = @current_user.email
    if @resume.present?
      @person.update(resume: @resume) if @resume.present?
    else
      check_resume_text
    end
  end

  def create_person_from_resume
    @resume_text = file_2_text(@resume.tempfile.path)
    @email = @resume_text.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)[0]
    @person = Person.find_or_create_by(email_address: @email)
    @person.update(resume: @resume) unless @person.resume.attached?
  end

  def check_resume_text
    return unless @person.resume.attached?

    extension = @person.resume.blob.content_type.split('/').last
    @person.update(resume_text: file_to_text(file_from_attachment.path, extension)) if @person.resume_text.empty?
  end

  def file_from_attachment
    file_url = @person.resume.service_url
    open(file_url)
  end

  def generate_scores

    match_score_status = MatchScoreStatus.find_by(person_id: @person.id)
    return if match_score_status.present? && match_score_status.in_progress?

    generate_score_params = { person_id: @person.id }
    generate_score_params.merge!(with_apply: true, current_user: @current_user) if @current_user.present?
    GenerateScoresJob.perform_later(generate_score_params)
  end

  def file_to_text(in_path, extension)
    result = ''
    if extension == '.pdf'
      result = pdf_2_text in_path
    elsif extension == 'docx'
      result = doc_2_text in_path
    elsif extension == '.doc'
      result = doc_2_text in_path
    elsif extension == '.txt'
      result = File.read in_path
    else
      Rails.logger.error "Unknown file extension #{in_path.last(4)}."
      result = ''
    end
    result.gsub("\u0000", '')
  end
end
