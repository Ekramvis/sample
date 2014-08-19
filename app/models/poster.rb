class Poster < ActiveRecord::Base

  # Gems
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_attached_file :thumbnail, styles: { thumb: '150x200#', grid: '450x600#' }

  # Associations
  has_many :poster_sections
  has_one :file_attachment, as: :attachable, dependent: :destroy

  # Attributes
  accepts_nested_attributes_for :poster_sections, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :file_attachment, allow_destroy: true, reject_if: :all_blank

  # Validations
  validates :title, presence: true
  validates_attachment_content_type :thumbnail, content_type: %w(image/jpeg image/jpg image/png image/gif)

end
