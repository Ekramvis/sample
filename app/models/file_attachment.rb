class FileAttachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true

  has_attached_file :attachment

  PDF_CONTENT = [
                  'application/pdf',
                  'application/x-pdf'
                ]

  WORD_CONTENT = [
                   'application/msword',
                   'applicationvnd.ms-word',
                   'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                 ]

  CSV_CONTENT = [
                  'application/zip',
                  'application/octet-stream',
                  'application/msexcel',
                  'application/vnd.ms-excel',
                  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                ]

  ALL_CONTENT = PDF_CONTENT + WORD_CONTENT + CSV_CONTENT

  # Validations
  validates :title, presence: true
  validates_attachment_presence :attachment
  validates_attachment_content_type :attachment,
                                    :content_type => ALL_CONTENT,
                                    :message => "Only PDF, WORD, and EXCEL files are allowed"

  def doc_image
    if PDF_CONTENT.include?(attachment_content_type)
      'PDF.png'
    elsif WORD_CONTENT.include?(attachment_content_type)
      'DOC.png'
    elsif CSV_CONTENT.include?(attachment_content_type)
      'CSV.png'
    end
  end

end
