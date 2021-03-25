class Address < ApplicationRecord
  after_update :set_default
  belongs_to :user
  has_many :orders

  enum address_type: {
      normal: 0,
      company: 1,
      home: 2,
      other: 3
  }

  validates_presence_of :address_code, :phone, :desc

  def city_name
    ChinaCity.get(address_code, prepend_parent: true) if address_code.present?
  end

  def places
    city_name.present? ? city_name.split(',') : []
  end

  def address_name
    "#{city_name} #{desc}"
  end

  def show_address_types
    {normal: '', company: '公司', home: '家', other: '其它'}
  end

  def show_address_type
    show_address_types[address_type.to_sym]
  end


  def set_default
    if self.default
      self.user.addresses.where(default: true).where.not(id: self.id).update_all default: false
    end
  end
end
