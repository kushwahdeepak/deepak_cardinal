require 'csv'
namespace :add_university_data do
  desc "Add university"
  task :us_universities => :environment do 
    puts "starting inserting university name"
    iterate_university_data
  end

  def load_universites_file file
    file_read = File.read(file)
    CSV.parse file_read, {
      headers: true,
      skip_blanks: true,
      converters: :date,
      skip_lines: /^(?:,\s*)+$/,
      encoding: 'windows-1251:utf-8'
    }
  end
    
  def iterate_university_data
    file = Rails.root.join("public/US_UNIVERSITIES.csv")
    csv = load_universites_file file
    csv.each do |row|
      params = row.to_hash.transform_keys{ |key| key.to_s.downcase.to_sym }.compact
      create_user_education params 
    end
  end

  def create_user_education params
    user_education = UserEducation.new(rank: params[:rank].to_i, name: params[:university].downcase, town: params[:city].downcase)
    if user_education.save!
      puts user_education.name
    else
      puts "error in name #{user_education.name}"
    end
  end
end
 
  