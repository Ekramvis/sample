class Group < ActiveRecord::Base
  # Gems
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_attached_file :grid, styles: { small: '450x450#', thumb: '100x100#' }
  has_attached_file :background, styles: { thumb: '100x100#', large: '720x', mega: '1600x' }, hash_data: ":class/banners/:id/:updated_at"

  # Associations
  has_many :groupings, dependent: :destroy
  has_many :posts, through: :groupings, source: :groupable, source_type: 'Post'
  has_many :images, as: :imageable, dependent: :destroy

  # Attributes
  accepts_nested_attributes_for :images, reject_if: :all_blank, allow_destroy: true

  # Validations
  validates :name, :grid, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates_attachment_content_type :grid, :content_type => %w(image/jpeg image/jpg image/png image/gif)
  validates_attachment_content_type :background, :content_type => %w(image/jpeg image/jpg image/png image/gif)

  # Callbacks
  before_save :downcase_name

  def downcase_name
    self.name = self.name.downcase
  end

  def group_members
    posts.order('date_posted DESC')
  end

  def questions
    Question.joins(:tags).where(tags: {name: self.name}).order('updated_at DESC')
  end
end
