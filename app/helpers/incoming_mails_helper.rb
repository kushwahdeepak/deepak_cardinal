class PlainEmailParser
    private
    def self.clean_up text
      #.gsub(/(?<!\n)\n(?!\n)/," ") #remove single new lines
      r_val = text
        .gsub(/#{URI::regexp}/, '') #rm urls
        .gsub("\r", "") #rm carriage returns
        .gsub(/<.*>/, "") #rm links
        .squeeze("\n")
        .squeeze(".").gsub("\n.\n","\n") #rm delimiter lines made of dots
        .squeeze("-").gsub("\n-\n","\n") #rm delimiter lines made of dashes
        .gsub("\u0000", '') #get rid of null chars
      r_val
    end

    def self.find_section_headers text
      header_idxs = []
      SECTION_TITLES.each do |title|
        idx = text.index title
        header_idxs << [title, idx] if idx.present?
      end
      header_idxs.sort!{ |a,b| a[1] <=> b[1] }
      missing_headers_error = header_idxs.empty? ||  header_idxs.last[0] != SECTION_TITLES.last
      Rails.logger.warn "Did not find all the headers reqauired for parsing" if missing_headers_error
      header_idxs
    end
    def self.extract_sections text, idxs
      sections = {}
      (0..idxs.length-2).each do |idx|
        s_idx = idxs[idx][1]
        e_idx = (idxs[idx+1][1]) - 1
        header = idxs[idx][0]
        content = text
          .slice(s_idx, e_idx - s_idx)
          .gsub(header, '')
          .strip
        sections[header] = content
      end
      sections
    end

    public
    SECTION_TITLES = [
      'Current experience',
      'Past experience',
      'Education',
      'Skills matching your job',
      'Highlight' ,
      'Contact Information',
      'You are receiving Job Applicant emails.']
    def self.parse plain_email
      return {} unless plain_email.present?
      sections = {}
      plain_email = clean_up plain_email
      ap "clean mail plain_email: #{plain_email}"
      idxs = find_section_headers plain_email
      sections = extract_sections plain_email, idxs
      ap sections
      sections
    end
  end
module IncomingMailsHelper
  def save_to_tmp_file contents, extension
    file = Rails.root.join('tmp', SecureRandom.uuid+'.'+extension)
    file.open("wb") { |f| f.write contents }
    file
  end

  def extract_job_id_from_subj subj
    subj
      &.gsub(/.*?\[/, "")
      &.gsub(/\].*/,"")
      &.to_i
  end

  def docx_2_text  in_path
    require 'docx'
    doc = Docx::Document.open(in_path)

    r_val = []
    doc.paragraphs.each do |p|
      r_val <<  p
    end
    r_val.join("\n")
  end

  def doc_2_text in_path
    require 'doc_ripper'
    
    
    DocRipper::rip(in_path)
  end

  def pdf_2_text in_path
    PDF::Reader.open(in_path) do |reader|
      Rails.logger.info "Converting : #{in_path}"
      pageno = 0
      txt = reader.pages.map do |page|
        pageno += 1
        begin
          Rails.logger.info  "Converting Page #{pageno}/#{reader.page_count}\r"
          page.text
        rescue
          Rails.logger.error  "Page #{pageno}/#{reader.page_count} Failed to convert"
          ''
        end
      end # pages map
      txt = txt.join("\n")
    end # reader
  end

  def file_2_text(in_path, file_extension = nil)
    result = ''
    extension = file_extension || in_path.last(4).downcase
    if extension == '.pdf'
      result = pdf_2_text in_path
    elsif  extension == 'docx'
      result = docx_2_text in_path
    elsif  extension == '.doc'
      result = doc_2_text in_path
    elsif extension == '.txt'
      result = File.read in_path
    else
      Rails.logger.error "Unknown file extension #{in_path.last(4)}."
      result = ''
    end

    result.present? ? result.gsub("\u0000", '') : ''
  end

  def extract_email_from_str str
    (str||'').scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)[0]
  end
end
