class ExportCandidatesService
  ATTRIBUTES = %w{name company_names school phone_number email_address linkedin_profile_url}.freeze

  def call
    past_week_top20_candidates
    to_csv
  end

  private

  def past_week_top20_candidates
    past_week = 1.week.ago.beginning_of_week..DateTime.now.beginning_of_week
    @persons = Person.joins('INNER JOIN submissions ON submissions.incoming_mail_id = people.incoming_mail_id').where(
        submissions: { created_at: past_week },
        tags: Person::TOP_2O_PERCENT_TAG
    )
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ATTRIBUTES
      @persons.each do |person|
        csv << ATTRIBUTES.map{ |attr| person.send(attr) }
      end
    end
  end
end
