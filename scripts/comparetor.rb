require 'json'
require 'awesome_print'

require 'httparty'

class Comparetor
  def self.compare
    dir_in = "/Users/makedon/_Carreer/Jobs/CardinalHire/code/comperaor-data/incoming_mail_parsed_mail/"
    gt_paths =  Dir.glob(dir_in + "*.gt.json")
    gt_paths.each(&method(:compare_single))
  end

  def self.normalize_value str
    str
      .gsub("to", "")
      .gsub("from", "")
      .gsub("More","")
      .gsub("\n","")
      .gsub("/n","")
      .gsub("-", "")
      .gsub(" ","")
      .gsub(",","")
  end

  def self.compare_single(gt_path)
    gt_hash = get_gt(gt_path)
    input_str = get_input(gt_path)
    result = JSON.parse(get_results(input_str).body)
    errors = []
    gt_hash.keys.each do |k|
      gt_val = normalize_value(gt_hash[k])
      result_val = normalize_value(result[k])
      if gt_val != result_val
        errors << "for key '#{k}', expected:\n'#{gt_val}'\ngot:\n'#{result_val}'."
      end
    end
    if errors.size > 0
      puts '/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'
      puts gt_path
      errors.each{|e| puts e}
      puts ',.,.,.,.,.,.,.,.,.,.,.,.,.,.,.'
      puts get_input gt_path
      puts ',.,.,.,.,.,.,.,.,.,.,.,.,.,.,.'
    end

  end


  def self.get_results(input)
    HTTParty.post("http://localhost:3000/incoming_mails/parse_plain", body: { plain: input})
  end

  def self.get_input(gt_path)
    File.read gt_path.gsub('gt.json', 'txt')
  end

  def self.get_gt(gt_path)
    JSON.parse(File.read gt_path)
  rescue JSON::ParserError => e
    p "\n\n\n\nFailed to parse file #{gt_path}.  Error: #{e.message}\n\n\n"
    {}
  end
end

Comparetor.compare_single "/Users/makedon/_Carreer/Jobs/CardinalHire/code/comperaor-data/"+
  "incoming_mail_parsed_mail/0c1b3b68-28c3-4dd1-ab82-58479167fbfd.gt.json"
