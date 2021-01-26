class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :set_desc, :set_server_admin, :server_admins, :get_desc, :set_desc]

  def index
    params[:status] ||= 'paid'
    @orders = Order.search_conn(params).order('orders.updated_at desc').page(params[:page]).per(20)
  end

  def show
    render layout: false
  end

  def server_admins
    render layout: false
  end

  def set_server_admin
    @order.update admin_id: params[:admin_id]
  end

  def get_desc
    render layout: false
  end

  def set_desc
    @order.update desc: params[:desc]
  end

  private
  def set_order
    @order = Order.find_by id: params[:id]
    redirect_to admin_orders_path, alert: '找不到数据' if @order.blank?
  end

end