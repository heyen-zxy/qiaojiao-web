class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :set_desc, :set_server_admin, :server_admins, :get_desc, :set_desc]

  def index
    params[:status] ||= 'paid'
    @orders = current_admin.orders.search_conn(params).order('orders.updated_at desc').page(params[:page]).per(20)
  end

  def show
    render layout: false
  end

  def server_admins
    render layout: false
  end

  def set_server_admin
    @order.update admin_id: params[:admin_id]
    NotificationJob.perform_later @order.id.to_s, 'work_message_send'
  end

  def get_desc
    render layout: false
  end

  def set_desc
    @order.update desc: params[:desc]
  end

  private
  def set_order
    @order = current_admin.orders.find_by id: params[:id]
    redirect_to admin_orders_path, alert: '找不到数据' if @order.blank?
  end

end
