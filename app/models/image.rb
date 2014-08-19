class Image < ActiveRecord::Base

  # Gems
  has_attached_file :image, styles: lambda { |attachment| attachment.instance.set_styles }

  # Constants
  IMAGE_TYPES = %w( Post Lab )

  # Associations
  belongs_to :imageable, polymorphic: true

  # Validations
  validates :imageable_type, inclusion: { :in => IMAGE_TYPES }
  validates_attachment_content_type :image, :content_type => %w(image/jpeg image/jpg image/png image/gif)

  # Methods
  def as_json opts
    {
      file: {
        :url        => image.url(:original),
        :image_type => image_content_type,
        :large      => image.url(:large),
        :medium     => image.url(:medium),
        :small      => image.url(:small)
      }
    }
  end

  def set_styles
    if imageable_type
      send "#{imageable_type.underscore}_styles"
    else
      lab_styles
    end
  end

  def post_styles
    {
      large: '1000x',
      small: '100x100#'
    }
  end

  def lab_styles
    {
      large: '690x410#',
      small: '150x90#'
    }
  end

end
