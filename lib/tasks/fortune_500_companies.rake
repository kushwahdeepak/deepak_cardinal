require 'csv'
namespace :filter_company_data do
  task :fortune_500_companies_data => :environment do 
    puts "starting inserting company name for filter"
    iterate_filter_company_data
  end

  def load_companies_file file
    file_read = File.read(file)
    CSV.parse file_read, {
      headers: true,
      skip_blanks: true,
      converters: :date,
      skip_lines: /^(?:,\s*)+$/,
      encoding: 'windows-1251:utf-8'
    }
  end
    
  def iterate_filter_company_data
    file = Rails.root.join("public/fortune_501.csv")
    csv = load_companies_file file #downloads file back from the cloud
    csv.each do |row|
      params = row.to_hash.transform_keys{ |key| key.to_s.downcase.to_sym }.compact
      create_company_data params 
    end
  end

  def create_company_data params
    company_row = CompanyProfile.new(company_name: params[:name].downcase!)
    if company_row.save!
      puts company_row.company_name
    else
      puts "error in name #{company_row.company_name}"
    end
  end
end
 
  