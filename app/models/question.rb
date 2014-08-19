class Question < ActiveRecord::Base

  # Gems
  searchkick
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Associations
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  has_many :views, as: :viewable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :tags

  # Validations
  validates :user, :title, :body, :tags_list_string, presence: true

  # Callbacks
  after_save :save_tags

  # Methods
  def search_data
    {
      title: title,
      body: body,
      tags: tags.map(&:name),
      created_at: created_at,
      views_count: views_count,
      popularity: votes_sum
    }
  end

  def tags_list_string= list
    @tags_list = list.split(',').map { |t| t.downcase.squish }
  end

  def tags_list_string
    tags_list.join(',')
  end

  def tags_list
    @tags_list ||= tags.pluck(:name)
  end

  def save_tags
    tags.each do |tag|
      tags.delete(tag) if !tags_list.include?(tag.name)
    end
    (tags_list - tags.pluck(:name)).each do |tag|
      tags << Tag.where(name: tag).first_or_create
    end
  end

  def editable_by? current_user
    current_user && user == current_user
  end

end
