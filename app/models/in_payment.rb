class InPayment < Payment
  include AASM
  belongs_to :order
  after_create_commit :unifiedorder
  STATUS = {wait: '新订单', apply: '已下单', pay: '支付成功'}

  aasm :status do
    state :apply, :initial => true
    state :apply, :pay


    event :do_apply do
      transitions :from => [:wait], :to => :apply
    end

    event :do_pay do
      transitions :from => :apply, :to => :pay
    end

  end

  def self.search_conn params
    payments = self.joins(:order, :user).all
    if params[:status].present?
      payments = payments.where(status: params[:status])
    end
    if params[:table_search].present?
      payments = payments.where('orders.no like ? or users.nick_name like ? or users.phone like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%")
    end
    if params[:date_from].present?
      payments = payments.where('payments.created_at >= ?', params[:date_from].to_datetime)
    end
    if params[:date_to].present?
      payments = payments.where('payments.created_at <= ?', params[:date_to].to_datetime.end_of_day)
    end
    payments
  end

  def view_amount
    amount / 100.0
  end

  def get_status
    InPayment::STATUS[status.to_sym]
  end

  def unifiedorder
    total_fee = Rails.env == 'production' ? amount : 1
    params = {
        body: '佳匠服务',
        out_trade_no: self.order.no,
        total_fee: total_fee, #amount
        spbill_create_ip: '127.0.0.1',
        notify_url: Settings.notify_url,
        trade_type: 'JSAPI',
        openid: user.open_id
    }
    payment_logger.info '========beigin unfiedorder============'
    r = WxPay::Service.invoke_unifiedorder params
    if r.success?
      self.do_apply! if self.may_do_apply?
      self.update apply_res: r[:raw]['xml'].to_json, prepay_id: r[:raw]['xml']['prepay_id']
    else
      payment_logger.info "=========unfiedorder error #{r}=============="
    end
  end

  def js_pay_req
    params = {
        prepayid: prepay_id, # fetch by call invoke_unifiedorder with `trade_type` is `JSAPI`
        noncestr: SecureRandom.hex(16),
    }
    r = WxPay::Service.generate_js_pay_req params
  end

  def order_query
    params = {out_trade_no: self.order.no}
    res = WxPay::Service.order_query params
    if res[:raw].present? && res[:raw]['xml'].present? && res[:raw]['xml']['return_code'] == 'SUCCESS'
      self.update response_data: res[:raw]['xml']
      self.do_pay! if self.may_do_pay?
      self.order.do_pay! if self.order.may_do_pay?
    end
    self
  end

  def times_order_query times=5
    times.times do |time|
      payment = self.order_query
      break if payment.pay?
      sleep 2
    end
  end


  def payment_logger
    Logger.new 'log/user_payment.log'
  end
end