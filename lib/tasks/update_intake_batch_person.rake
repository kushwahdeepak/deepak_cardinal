require 'csv'
namespace :scheduled do
  task :update_person, [:name] => [:environment] do |task, args|
    puts "starting intake batches"
    load_csv = iterate_input_rows args[:name]
  end

  def load_csv_file file
    file_read = File.read(file)
    CSV.parse file_read, {
      headers: true,
      skip_blanks: true,
      converters: :date,
      skip_lines: /^(?:,\s*)+$/,
      encoding: 'windows-1251:utf-8'
    }
  end
    
  def iterate_input_rows name
    file = Rails.root.join("public", name)
    csv = load_csv_file file #downloads file back from the cloud
    csv.each do |row|
      params = row.to_hash.transform_keys{ |key| key.to_s.downcase.to_sym }.compact
      update_person params 
    end
  end

  def update_person params
    person = Person.find_by(email_address: params[:email_address])
    begin
      person.update! params
    rescue => exception
      puts "No data available to update"
    end
  end
end
 
  