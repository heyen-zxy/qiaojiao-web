class Norm < ApplicationRecord
  belongs_to :product
  validates_presence_of :price, :name
  validates :price,  inclusion: {in: 1..9999999999 }, if: Proc.new { |norm| norm.price.present? }

  def view_price
    price.to_f / 100
  end

  def user_commission user=nil
    if user&.company.present?
      if high_commission.to_i > 0
        high_commission.to_i
      else
        commission.to_i
      end
    else
      commission.to_i
    end
  end

  def view_user_commission user=nil
    user_commission(user) / 100.0
  end

  def commission
    product.commission * price / 100
  end

  def high_commission
    product.high_commission * price / 100
  end

  def view_commission
    commission.to_f  / 100
  end

  def view_high_commission
    high_commission.to_f / 100
  end

end
