class EmployerCompanyProfile < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true

  # has_attached_file :logo,
  #   # In order to determine the styles of the image we want to save
  #   # e.g. a small style copy of the image, plus a large style copy
  #   # of the image, call the check_file_type method
  #   styles: lambda { |a| a.instance.check_file_type },
  #   processors: lambda {
  #     |a| a.is_video? ? [ :ffmpeg ] : [ :thumbnail ]
  #   },
  #   storage: :s3,
  #   s3_protocol: :https,
  #   s3_permissions: :private,
  #   path: ":rails_root/public:url",
  #   default_url: ":rails_root/public/missing.png",
  #   url: "/system/:class/:attachment/:id_partition/:style/:hash.:extension",
  #   hash_secret: ENV.fetch('PAPERCLIP_HASH_SECRET')
  #
  # validates_attachment :logo,
  # content_type: {
  #   content_type: [
  #     "image/jpeg",
  #     "image/gif",
  #     "image/png",
  #     "video/mp4",
  #     "video/quicktime",
  #     "image/jpg",
  #     "image/jpeg",
  #     "image/png",
  #     "image/gif",
  #     "audio/mpeg",
  #     "audio/x-mpeg",
  #     "audio/mp3",
  #     "audio/x-mp3",
  #     "file/txt",
  #     "application/doc",
  #     "application/docx",
  #     "application/pdf",
  #     "application/msword",
  #     "application/vnd.ms-excel",
  #     "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  #     "application/vnd.ms-powerpoint",
  #     "application/pdf",
  #     "application/vnd.ms-excel",
  #     "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  #     "application/msword",
  #     "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  #     "text/plain"
  #   ],
  #   message: "Sorry! We do not accept the attached file type. Please try converting or saving your file in a more recent format."
  #   },
  #   size: {
  #     in: 0..500.kilobytes
  #   },
  # if: Proc.new {|a| a.logo.present? }

  # Before applying the Imagemagick post processing to this record
  # check to see if we indeed wish to process the file. In the case
  # of audio files, we don't want to apply post processing
  #before_post_process :apply_post_processing?

  # Helper method that uses the =~ regex method to see if
  # the current file_upload has a content_type
  # attribute that contains the string "image" / "video", or "audio"
  def is_image?
    self.logo.content_type =~ %r(image)
  end

  def is_video?
    self.logo_content_type =~ %r(video)
  end

  def is_audio?
    self.logo_content_type =~ /\Aaudio\/.*\Z/
  end

  def is_plain_text?
    self.logo_file_name =~ %r{\.(txt)$}i
  end

  def is_excel?
    self.logo_file_name =~ %r{\.(xls|xlt|xla|xlsx|xlsm|xltx|xltm|xlsb|xlam|csv|tsv)$}i
  end

  def is_word_document?
    self.logo_file_name =~ %r{\.(docx|doc|dotx|docm|dotm)$}i
  end

  def is_powerpoint?
    self.logo_file_name =~ %r{\.(pptx|ppt|potx|pot|ppsx|pps|pptm|potm|ppsm|ppam)$}i
  end

  def is_pdf?
    self.logo_file_name =~ %r{\.(pdf)$}i
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
