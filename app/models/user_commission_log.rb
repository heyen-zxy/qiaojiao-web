class UserCommissionLog < ApplicationRecord
  acts_as_paranoid
  belongs_to :user_commission
  belongs_to :user
  belongs_to :order, optional: true
  after_create :set_user_commission

  enum status: {
      wait: 1,
      done: 2,
      failed: 3
  }

  enum commission_type: {
      served: 1, #完成服务生成的
      cash: 2, # 提现
      adjust: 3
  }

  def self.cn_statuses
    {wait: '待处理', done: '已处理', failed: '提现失败'}
  end

  def self.cn_commission_types
    {served: '完成服务', cash: '提现', adjust: '调整'}
  end

  def get_commission_type
    UserCommissionLog.cn_commission_types[self.commission_type.to_sym] if self.commission_type.present?
  end

  def get_status
    UserCommissionLog.cn_statuses[self.status.to_sym] if self.status.present?
  end

  # 订单完成生成佣金记录
  def self.set_commission order
    if order.present? && order.share_user.present? && order.commission > 0
      user = order.share_user
      return if self.find_by(order: order, user: user).present?
      log = self.served.done.new order: order, user: user
      log.commission =  order.commission
      c = UserCommission.find_or_initialize_by user: user
      log.user_commission = c
      log.save!
    end
  end

  def set_user_commission
    c = UserCommission.find_or_initialize_by user: user
    self.commission_before =  c.commission

    c.commission += self.commission
    c.commission_wait += self.commission
    c.share_order += 1 if self.order.present?
    self.commission_after =  c.commission

    #提现
    c.commission_paid += self.commission.abs if self.commission < 0

    c.save && self.save
  end

  def view_commission
    commission.to_f / 100
  end

  def view_commission_before
    commission_before.to_f / 100
  end

  def view_commission_after
    commission_after.to_f / 100
  end

  def self.search_conn params
    logs = self.joins(:user)
    if params[:user_id].present?
      logs = logs.where('user_commission_logs.user_id': params[:user_id])
    end
    if params[:status].present?
      logs = logs.where(status: params[:status])
    end
    if params[:commission_type].present?
      logs = logs.where(commission_type: params[:commission_type])
    end
    if params[:table_search].present?
      logs = logs.where('users.nick_name like ? or users.phone like ? ', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
    end
    logs
  end

end
