module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :ratings, as: :rateable, dependent: :destroy
  end

  def rating
    @rating ||= ratings.average(:rating).try(:round) || 0
  end

  def ratings_count
    @ratings_count ||= ratings.count
  end

end