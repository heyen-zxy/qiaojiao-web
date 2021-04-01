class UserCommissionLog < ApplicationRecord
  acts_as_paranoid
  belongs_to :user_commission
  belongs_to :user
  belongs_to :order

  def self.set_commission order
    if order.present? && order.share_user.present? && order.commission > 0
      user = order.share_user
      log = self.new order: order, user: user
      c = UserCommission.find_or_initialize_by user: user
      c.share_order += 1
      log.commission =  order.commission
      log.commission_before =  c.commission
      c.commission += order.commission
      log.commission_after =  c.commission
      c.commission_wait += order.commission
      log.user_commission = c
      log.save!
    end
  end

end
