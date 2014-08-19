class User < ActiveRecord::Base

  # Gems
  has_secure_password
  acts_as_towncrier_targets
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_attached_file :photo, styles: { medium: '120x120#', thumb: '50x50#' }
  searchkick

  # Constants
  STATES = %w( active suspended )
  KNOWLEDGE_LEVELS = %w( novice intermediate advanced expert )
  TIME_FRAMES = [ '1-3 months', '3-6 months', '6-12 months', '12 months+' ]
  has_stateable STATES

  # Attributes
  attr_accessor :in_initial_signup
  store :metadata, accessors: [ :building_lab_time_frame ]

  # Associations
  has_many :pursuits, dependent: :destroy
  has_many :roles, through: :pursuits
  has_many :action_tokens, as: :tokenable, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :companies, dependent: :destroy
  has_many :labs, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :service_providers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :views, dependent: :destroy

  # Scopes
  scope :admins, -> { where(is_admin: true) }

  # Validations
  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :state, inclusion: { :in => STATES }
  validates :knowledge_level, inclusion: { :in => KNOWLEDGE_LEVELS }, allow_nil: true, allow_blank: true
  validates_attachment_content_type :photo, :content_type => %w(image/jpeg image/jpg image/png image/gif)

  # Omniauth
  def self.from_omniauth(auth)
    self.where(auth.slice(:provider, :uid)).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    password = SecureRandom.hex
    new_user = self.create(password: password, password_confirmation: password) do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.name = auth.info.name
      user.email = auth.info.email
      if auth.provider == "linkedin"
        user.oauth_expires_at = Time.at(auth.extra.access_token.params[:oauth_expires_in].to_i)
      else
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      end
    end

    UserMailer.welcome(new_user).deliver if new_user.errors.blank?
    new_user
  end

  # Methods
  def search_data
    {
      name: name,
      organization: organization
    }
  end

  def notifications
    @notifications ||= towncries.unread
  end

end
