module Parser::Processable
  def extract_email str
    (str||'').scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)[0]
  end

  def extract_urls(plain_text: '')
    urls = (plain_text || '').scan(/(http|https|ftp|ftps)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/)
    if urls.class == Array && urls.length > 0
      return urls.flatten.uniq!
    end
    return []
  end

  def extract_contract_id(urls =[])
    contract_id = nil 
    project_id = nil
    urls.each do |url|
      if url.match?('contractId') || url.match('projectId')
        arr = url.split("&amp")
        arr.each do |str|
          if str.match?('contractId')
            contract_id = str.split('=')[1]
          end

          if str.match?('project')
            project_id = str.split('=')[1]
          end

        end # EOL
        break
      end
    end # EOL
    return {contract_id: contract_id, project_id: project_id}
  end

  def extract_name(email_subject: '')
    if email_subject.include?('New application')
      arr = email_subject.split('from')
      return arr.pop
    end
    return ''
  end

end


## For reference
# A linkedin job url sample
# we need to extract contract_id or project_id 
# these are two tell us which job a candidate is applying on .
# https://www.linkedin.com/comm/talent/redirect/batchReview?status=applicants&amp;profile=AEMAABQXuXMBXOimX3maP_1JmjgiN3zwEjEGzd0&amp;rightRail=jobApplication&amp;contractId=247899636&amp;project=417038466&amp;trk=eml-email_jobs_new_applicant_01-email_jobs_new_applicant-12-profile_application&amp;trkEmail=eml-email_jobs_new_applicant_01-email_jobs_new_applicant-12-profile_application-null-%7E8yblxz%7Ekgrzlgfc%7Ei7-null-talent%7Eredirect%7Ebatch%7Ereview&amp;lipi=urn%3Ali%3Apage%3Aemail_email_jobs_new_applicant_01%3BXsFcRsA%2FT0GImlbUrOc8Sg%3D%3D

# sample regex
# scan(/(https)\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?/)
