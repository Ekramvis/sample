module GeoAddressable
  extend ActiveSupport::Concern

  included do
    geocoded_by :full_street_address
    validates :address, :address_city, :address_state, :address_zip, presence: true
    after_validation :geocode, :if => ->(obj){ obj.address.present? and obj.address_changed? }
  end

  def full_street_address
    "#{address}
    #{address_city}, #{address_state} #{address_zip}"
  end

  def full_contact_info
    str = [ contact_name ]
    str << address
    str << address2 if address2.present?
    str << "#{address_city}, #{address_state} #{address_zip}"
    str << contact_phone
    str.compact.join("\n")
  end

end