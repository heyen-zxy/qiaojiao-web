class Order < ApplicationRecord
  include AASM
  acts_as_paranoid
  belongs_to :user
  belongs_to :share_user, class_name: 'User', optional: true
  belongs_to :address, optional: true
  belongs_to :admin, optional: true
  has_and_belongs_to_many :norms, join_table: 'order_norms'
  has_many :order_norms
  after_create :set_no, :set_amount
  has_many :payments
  belongs_to :commission_log, optional: true
  has_and_belongs_to_many :attachments, join_table: 'model_attachments', foreign_key:  :model_id, class_name: 'ServerAttachment', association_foreign_key: :attachment_id
  STATUS = { wait: '待付款', paid: '已支付', served: '已完成', cancel: '已取消'}
  aasm :status do
    state :wait, :initial => true
    state :paid, :served, :cancel

    #支付
    event :do_pay do
      transitions :from => [:wait], :to => :paid, after: Proc.new{after_pay}
    end

    #取消
    event :do_cancel do
      transitions :from => [:wait], :to => :cancel
    end

    #收货
    event :do_server do
      transitions :from => :paid, :to => :served, after: Proc.new{do_after_server}
    end

      # #收货
      # event :do_done do
      #   transitions :from => :send, :to => :receive
      # end

      # #申请售后
      # event :do_after_sale do
      #   transitions :from => [:send, :receive], :to => :after_sale
      # end

      # #售后
      # event :do_after_sale do
      #   transitions :from => :receive, :to => :after_sale
      # end
      #
      # #售后
      # event :do_after_failed do
      #   transitions :from => :apply_after, :to => :after_failed
      # end

  end

  def current_payment
    payments.last
  end

  def self.stat
  end

  def get_status
    Order::STATUS[self.status.to_sym]
  end

  def set_no
    self.update no: "#{DateTime.now.strftime('%Y%m%d%H%M%S')}#{self.id}"
  end

  def set_amount
    self.update amount: (order_norms.sum :amount)
  end

  def view_amount
    amount.to_f / 100
  end

  def view_commission
    commission.to_f / 100
  end


  def after_pay
    self.update payment_at: DateTime.now
    set_sale
  end

  def set_sale
    self.order_norms.each do |order_norm|
      order_norm.product.set_sale order_norm.number, order_norm.amount
    end
  end

  def do_after_server
    set_server_at
    set_commission
  end

  def set_commission
    set_user_commission
    set_admin_commission
  end

  def set_user_commission
    amount = 0
    if self.share_user.present?
      order_norms.each do |order_norm|
        amount += order_norm.norm.user_commission(self.share_user) * order_norm.number
      end
    end
    if amount > 0
      self.update commission: amount
      UserCommissionLog.set_commission self
    end
  end

  def set_admin_commission
    amount = 0
    if self.admin.present?
      order_norms.each do |order_norm|
        amount += order_norm.norm.admin_commission * order_norm.number
      end
    end
    if amount > 0
      self.update admin_commission: amount
      AdminCommissionLog.set_commission self
    end
  end

  def set_server_at
    self.update server_at: DateTime.now
  end

  # h5CtjMGbiLCl7aICaxndzkAa5ExNx7_qVCYN4oiIJSM
  # 模板编号
  # 2025
  # 标题
  # 派工通知
  # 派工人员
  # {{name1.DATA}}
  # 联系人
  # {{name3.DATA}}
  # 联系电话
  # {{phone_number4.DATA}}
  # 订单编号
  # {{character_string6.DATA}}
  # 派工内容
  # {{thing2.DATA}}
  #
  # YEWcpJmcPiVeAg6igaGkcW1cSFGKn8ZaZOM5RZIpBZg
  # 模板编号
  # 936
  # 标题
  # 订单状态变动通知
  # 详细内容
  # 订单号
  # {{character_string1.DATA}}
  # 订单状态
  # {{phrase2.DATA}}
  # 更新时间
  # {{date4.DATA}}
  # 备注
  # {{thing5.DATA}}
  #
  # 模板ID
  # A0-kDcODKZr7h-Zc-EEKQFzhaKABp6Ug0m5LfKcdesk
  # 模板编号
  # 669
  # 付款成功通知
  # 商品详情
  # {{thing3.DATA}}
  # 付款时间
  # {{date2.DATA}}
  # 订单编号
  # {{character_string1.DATA}}
  # 场景说明
  # 订单支付成功通知

  class << self
    def status_select
      STATUS.collect{|key, value| [value, key]}
    end

    #{norm_array: [{id: 1, number: 2}, {id: 4, number: 1}]}
    def save_orders user, params={}
      order = user.orders.new
      from_token = params['from_token']
      if from_token.present?
        share_user = User.find_by(id: from_token)
      end
      order.share_user = share_user
      norm_array = JSON.parse params['norm_array']
      norm_array ||= []
      norm_array.each do |norm_hash|
        norm = Norm.joins(:product).where('norms.id': norm_hash['id'], 'products.status': 'on').first
        number = norm_hash['number']
        number ||= 1
        order_norm = OrderNorm.new norm: norm, product: norm.product, number: number, price: norm.price, amount: norm.price*number
        order.order_norms << order_norm
      end
      order.valid?
      order.save
      order
    end

    def search_conn params={}
      orders = self.includes({norms: :product}, :user).references :all
      if params[:status].present?
        orders = orders.where(status: params[:status])
      end

      if params[:table_search].present?
        orders = orders.where('users.phone like ? or users.nick_name like ? or products.name like ? or orders.no like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      orders
    end
  end
end
