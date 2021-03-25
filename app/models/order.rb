class Order < ApplicationRecord
  include AASM
  belongs_to :user
  belongs_to :share_user, class_name: 'User', optional: true
  belongs_to :address, optional: true
  belongs_to :admin, optional: true
  has_and_belongs_to_many :norms, join_table: 'order_norms'
  has_many :order_norms
  after_create :set_no, :set_amount
  STATUS = { wait: '待付款', paid: '已支付', server: '已完成', cancel: '已取消'}
  aasm :status do
    state :wait, :initial => true
    state :paid, :server, :cancel

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
      transitions :from => :paid, :to => :served, after: Proc.new{set_server_at}
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


  def after_pay
    self.update payment_at: DateTime.now
    set_sale
  end

  def set_sale
    self.order_norms.each do |order_norm|
      order_norm.product.set_sale order_norm.number, order_norm.amount
    end
  end

  def set_server_at
    self.update server_at: DateTime.now
  end

  class << self
    def status_select
      STATUS.collect{|key, value| [value, key]}
    end

    #{norm_array: [{id: 1, number: 2}, {id: 4, number: 1}]}
    def save_orders user, params={}
      order = user.orders.new
      from_token = params['from_token']
      if from_token.present?
        share_user = User.find_by(share_token: from_token)
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
      p order.errors, 111
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
