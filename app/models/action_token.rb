class ActionToken < ActiveRecord::Base

  # Constants
  ACTION_TYPES = %w( password_reset )

  # Associations
  belongs_to :tokenable, polymorphic: true

  # Validations
  validates :tokenable, :action_type, presence: true
  validates :action_type, inclusion: { :in => ACTION_TYPES }

  # Callbacks
  before_create :set_token

  # Methods
  def set_token
    begin
      self.token = SecureRandom.hex.first(10)
    end while self.class.exists?(token: token)
  end

end
