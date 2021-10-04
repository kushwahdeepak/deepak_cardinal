def download_to_temp_path person
  tmp_path = File.join('./tmp', person.resume.filename.to_s)
  File.open(tmp_path, 'wb') do |file|
    person.resume.download { |chunk| file.write(chunk) }
  end
  tmp_path
end
namespace :ai_prep do
  desc "Go through people and extract resume text"
  task extract_resume_text: :environment do
    include IncomingMailsHelper
    people_with_resumes =  Person.all.select{|p| p.resume.attached?}
    ok_count = bad_count = 0
    people_with_resumes.each_with_index do |person, idx|
      begin
        puts "updating person_#{person.id}, (#{idx+1} of #{people_with_resumes.size})."
        tmp_path = download_to_temp_path person
        person.update(resume_text:file_2_text(tmp_path))
      rescue StandardError => e
        puts ("update failed: #{e.message}.")
        bad_count += 1
      else
        ok_count += 1
      ensure
        File.delete(tmp_path)
      end

    end
  end
end
