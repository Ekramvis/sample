class Download < ActiveRecord::Base

  # Associations
  has_one :file_attachment, as: :attachable, dependent: :destroy

  # Attributes
  accepts_nested_attributes_for :file_attachment, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates_associated :file_attachment
  validates_presence_of :file_attachment

end
