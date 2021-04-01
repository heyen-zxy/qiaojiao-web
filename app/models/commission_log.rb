class CommissionLog < ApplicationRecord
  STATUS = { wait: '待支付', paid: '已支付', cancel: '已取消'}
  include AASM
  aasm :status do
    state :wait, :initial => true
    state :paid, :served, :cancel

    #支付
    event :do_pay do
      transitions :from => [:wait], :to => :paid
    end

    #取消
    event :do_cancel do
      transitions :from => [:wait], :to => :cancel
    end
  end
end
