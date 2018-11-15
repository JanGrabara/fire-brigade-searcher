class Firestation < ApplicationRecord

    geocoded_by :address
    after_validation :geocode

    def address
        [street, city, postal_code, country].compact.join(', ')
        end
end
