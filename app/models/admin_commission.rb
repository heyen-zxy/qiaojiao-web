class AdminCommission < ApplicationRecord
  acts_as_paranoid
  belongs_to :admin

  def view_commission
    commission / 100.0
  end

  def view_commission_wait
    commission_wait / 100.0
  end

  def view_commission_paid
    commission_paid / 100.0
  end
end
