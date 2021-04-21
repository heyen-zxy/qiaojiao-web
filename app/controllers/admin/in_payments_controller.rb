class Admin::InPaymentsController < Admin::BaseController
  def index
    params[:status] ||= 'pay'
    all_payments = current_admin.in_payments.search_conn(params)
    @amount = all_payments.sum(:amount) / 100.0
    @payments = all_payments.order('updated_at desc').page(params[:page]).per(20)
  end
end
