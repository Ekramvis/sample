class PosterSection < ActiveRecord::Base

  # Gems
  has_attached_file :image, styles: { thumb: '100x200#', large: '300x600#' }

  # Associations
  belongs_to :poster

  # Validations
  validates :title, :description, presence: true
  validates_attachment_content_type :image, content_type: %w(image/jpeg image/jpg image/png image/gif)

end
