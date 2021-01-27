class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :address_code, :phone, :desc

  def city_name
    ChinaCity.get(address_code, prepend_parent: true) if address_code.present?
  end

  def address_name
    "#{city_name}#{desc}"
  end
end
