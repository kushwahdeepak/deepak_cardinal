desc 'update candidate source with value manual column to salesql_email'
task update_source: :environment do
    persons = Person.where(source: "manual")
    count = 0
    persons.each do |person|
        person.update(source: "salesql_email")
        count = count + 1
    end
    puts "#{count} persons updated"
end
