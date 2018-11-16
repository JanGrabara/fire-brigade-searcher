class Search
  include ActiveModel::Validations

  attr_accessor :city, :street, :radius

  validates :city, :radius, length: { minimum: 1 }
  validates :radius, format: { with: /\A\d+\z/, message: 'Integer only. No sign allowed.'}

  def create_query
    street.to_s.empty? ? city.to_s : "#{city}, #{street}"
  end


end
