class Firestation < ApplicationRecord
  geocoded_by :address
  after_validation :geocode
  validates :city, :country, :postal_code, presence: true

  def address
    [street, city, postal_code, country].compact.join(', ')
      end
end
