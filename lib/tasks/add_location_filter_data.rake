require 'csv'
namespace :filter_location_data do
  task :location_data => :environment do 
    puts "starting inserting company name for filter"
    iterate_filter_location_data
  end

  def load_location_file file
    file_read = File.read(file)
    CSV.parse file_read, {
      headers: true,
      skip_blanks: true,
      converters: :date,
      skip_lines: /^(?:,\s*)+$/,
      encoding: 'windows-1251:utf-8'
    }
  end
    
  def iterate_filter_location_data
    file = Rails.root.join("public/list_of_topcontouries_in_us.csv")
    csv = load_location_file file #downloads file back from the cloud
    csv.each do |row|
      params = row.to_hash.transform_keys{ |key| key.to_s.downcase.to_sym }.compact
      create_location_data params 
    end
  end

  def create_location_data params
    params[:country] = "usa"
    location_row = Location.new(params)
    if location_row.save!
      puts location_row.city
    else
      puts "error in name #{location_row.city}"
    end
  end
end
