class Post < ActiveRecord::Base

  # Modules
  include Favoritable

  # Gems
  extend FriendlyId
  friendly_id :title, use: :slugged
  has_attached_file :thumbnail, styles: { thumb: '100x100#', grid: '450x450#' }
  has_attached_file :background, styles: { thumb: '100x100#', grid: '450x450#', large: '720x', mega: '1600x', banner: '1000x400#' }, hash_data: ":class/banners/:id/:updated_at"
  searchkick

  # Constants
  POST_TYPES = %w( guide blog resource )

  # Associations
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :groupings, as: :groupable, dependent: :destroy
  has_many :groups, through: :groupings
  has_many :file_attachments, as: :attachable, dependent: :destroy

  # Attributes
  accepts_nested_attributes_for :file_attachments, allow_destroy: true, reject_if: :all_blank

  # Scopes
  scope :blogs,     -> { where(post_type: 'blog') }
  scope :guides,    -> { where(post_type: 'guide') }
  scope :resources, -> { where(post_type: 'resource') }
  scope :featured,  -> { where(is_featured: true) }

  # Validations
  validates :title, :content, :background, presence: true
  validates :post_type, inclusion: { :in => POST_TYPES }
  validates_attachment_content_type :background, :content_type => %w(image/jpeg image/jpg image/png image/gif)
  validates_attachment_content_type :thumbnail, :content_type => %w(image/jpeg image/jpg image/png image/gif)

  # Callbacks
  before_save :ensure_date_posted

  # Methods
  def ensure_date_posted
    self.date_posted = created_at if date_posted.blank?
  end

  def search_data
    {
      title: title,
      content: content,
      author: user.name,
      post_type: post_type,
      date_posted: date_posted
    }
  end

  def thumbnail_field
    thumbnail.present? ? thumbnail : background
  end

  def similar_posts
    2.times.inject([]) do |sum, _|
      post = (self.class.send("#{post_type}s") - [ self, sum ].flatten).sample
      sum << post
    end.compact
  end

end
