class Tag < ActiveRecord::Base

  # Associations
  has_and_belongs_to_many :questions

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false, message: 'This needs a custom message' } # ????????????????????????

  # Callbacks
  before_create :downcase_name

  # Methods
  def downcase_name
    self.name = name.downcase if name
  end

end
