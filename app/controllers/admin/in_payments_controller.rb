class Admin::InPaymentsController < Admin::BaseController
  def index
    params[:status] ||= 'pay'
    @payments = InPayment.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end
end
