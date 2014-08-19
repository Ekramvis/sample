class Slide < ActiveRecord::Base

  # Gems
  has_attached_file :background, styles: { small: '400x160#', large: '1000x400#' }, hash_data: ":class/banners/:id/:updated_at"

  # Validations
  validates :title, :link_url, :background, :duration, :timeshift, presence: true
  validates :duration, :timeshift, numericality: { only_integer: true }
  validates_attachment_content_type :background, :content_type => %w(image/jpeg image/jpg image/png image/gif)
  validates_format_of :link_url, with: /\A\//
end
