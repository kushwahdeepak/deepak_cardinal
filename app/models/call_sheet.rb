class CallSheet < ApplicationRecord
  belongs_to :user
  belongs_to :person, inverse_of: :call_sheet
  has_many :calls, inverse_of: :call_sheet, :dependent => :destroy
  has_many :submittals, inverse_of: :call_sheet, :dependent => :destroy
  has_many :phone_interviews, inverse_of: :call_sheet, :dependent => :destroy
  has_many :onsite_interviews, inverse_of: :call_sheet, :dependent => :destroy
  has_many :placements, inverse_of: :call_sheet, :dependent => :destroy

  default_scope { order('updated_at DESC') }

  accepts_nested_attributes_for :calls, :allow_destroy => true
  accepts_nested_attributes_for :submittals, :allow_destroy => true
  accepts_nested_attributes_for :phone_interviews, :allow_destroy => true
  accepts_nested_attributes_for :onsite_interviews, :allow_destroy => true
  accepts_nested_attributes_for :placements, :allow_destroy => true

  # Before applying the Imagemagick post processing to this record
  # check to see if we indeed wish to process the file. In the case
  # of audio files, we don't want to apply post processing
  #before_post_process :apply_post_processing?

  # Helper method that uses the =~ regex method to see if
  # the current file_upload has a content_type
  # attribute that contains the string "image" / "video", or "audio"
  def is_image?
    self.call_sheet_upload.content_type =~ %r(image)
  end

  def is_video?
    self.call_sheet_upload_content_type =~ %r(video)
  end

  def is_audio?
    self.call_sheet_upload_content_type =~ /\Aaudio\/.*\Z/
  end

  def is_plain_text?
    self.call_sheet_upload_file_name =~ %r{\.(txt)$}i
  end

  def is_excel?
    self.call_sheet_upload_file_name =~ %r{\.(xls|xlt|xla|xlsx|xlsm|xltx|xltm|xlsb|xlam|csv|tsv)$}i
  end

  def is_word_document?
    self.call_sheet_upload_file_name =~ %r{\.(docx|doc|dotx|docm|dotm)$}i
  end

  def is_powerpoint?
    self.call_sheet_upload_file_name =~ %r{\.(pptx|ppt|potx|pot|ppsx|pps|pptm|potm|ppsm|ppam)$}i
  end

  def is_pdf?
    self.call_sheet_upload_file_name =~ %r{\.(pdf)$}i
  end

  def has_default_image?
    is_audio?
    is_plain_text?
    is_excel?
    is_word_document?
  end

  # If the uploaded content type is an audio file,
  # return false so that we'll skip audio post processing
  def apply_post_processing?
    if self.has_default_image?
      return false
    else
      return true
    end
  end

  # Method to be called in order to determine what styles we should
  # save of a file.
  def check_file_type
    if self.is_image?
      {
        :thumb => "200x200>",
        :medium => "500x500>"
      }
    elsif self.is_pdf?
      {
        :thumb => ["200x200>", :png],
        :medium => ["500x500>", :png]
      }

    elsif self.is_video?
      {
        :thumb => {
          :geometry => "200x200>",
          :format => 'jpg',
          :time => 0
        },
        :medium => {
          :geometry => "500x500>",
          :format => 'jpg',
          :time => 0
        }
      }
    elsif self.is_audio?
      {
        :audio => {
          :format => "mp3"
        }
      }
    else
      {}
    end
  end
end
