require 'rails_helper'
RSpec.describe IncomingMailsHelper, type: :helper do

  it "extract .pdf files" do
      r = helper.file_2_text( Rails.root.join('spec/fixtures/incoming_mails', 'resume.pdf').to_s)
      puts r
      expect(r).to include 'baron.a.mui@gmail.com'
  end
  it 'extracts emails from long strings' do
    path_in = Rails.root.join('spec/fixtures/incoming_mails','decoded_resume.txt').to_s
    str_in = File.read(path_in)
    expect(helper.extract_email_from_str(str_in)).to eq 'baron.a.mui@gmail.com'
  end

  it "save_to_tmp_file" do
    puts helper.save_to_tmp_file("abc","pdf")
  end

  describe "PlainEmailParser" do
    describe "simplify_newlines" do
      it "simplifies new lines" do
        expect(PlainEmailParser::clean_up("abc\nxyz\n\n123")).to eq "abc\nxyz\n123"
      end
      it "removes carriage rturns " do
        expect(PlainEmailParser::clean_up("abc\n\rxyz\n\r\n\r123")).to eq "abc\nxyz\n123"
      end
    end
    
    describe "find_section_headers" do
      it 'finds the headers' do
        input = '    Current experience   Past experience   Education  Skills matching your job   You are receiving Job Applicant emails.'
        #########0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
        #########0         1         2         3         4         5         6         7         8         9         10        11        12
        exp = [
          ['Current experience',4],
          ['Past experience', 25],
          ['Education', 43],
          ['Skills matching your job', 54 ],
          ['You are receiving Job Applicant emails.', 81]
        ]
        act = PlainEmailParser::find_section_headers input
        expect(act).to eq exp
      end
    end
    describe "extract_sections" do
      it "extracts the sections" do
        input_text = '000 Current experience 111 Past experience 222 Education 66 Skills matching your job 333 You are receiving Job Applicant emails. 555'
        ##############0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
        ##############0         1         2         3         4         5         6         7         8         9         10        11        12      #
        input_idxs =       exp = [
          ['Current experience',4],
          ['Past experience', 27],
          ['Education', 47],
          ['Skills matching your job', 60 ],
          ['You are receiving Job Applicant emails.', 89]
        ]      #
        exp =
          {
            'Current experience' => '111',
            'Past experience' => '222',
            'Education' => '66',
            'Skills matching your job' => '333'
          }
        act =  PlainEmailParser::extract_sections input_text, input_idxs
        expect(act).to eq exp
      end
    end
    describe "find_section_headers" do
      it 'finds the headers' do
        ap PlainEmailParser::parse @email
      end
    end
  end
end
