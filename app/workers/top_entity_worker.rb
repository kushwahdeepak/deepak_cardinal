class TopEntityWorker
  include Sidekiq::Worker

  def perform
    # persons = Person.where.not(tags: Person::TOP_SCHOOL_TAG).or(Person.where.not(tags: Person::TOP_COMPANY_TAG)).uniq
    count = 0
    Person.all.each do |person|

      params = {}
      person.classify_rank params
      next unless person.save
      count = count + 1
    end
    puts "#{count} persons updated!"
  end
end
