namespace :filter_table do
  desc "Clear all unwanted data from people table"
  task :phone_number => :environment do
    persons = Person.where.not(phone_number: nil)
    count = 0
    persons.each do |person|
      if person.phone_number.to_i.digits.length < 9
        person.update(phone_number: nil)
        count = count + 1
      end
    end
    puts "#{count} persons updated"
  end
end