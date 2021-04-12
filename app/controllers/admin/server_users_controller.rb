class Admin::ServerUsersController < Admin::BaseController
  before_action :set_admin, only: [:cash, :cash_form]
  def index
    params[:status] ||= 'on'
    @admins = Admin.joins(:role).where('roles.tag': :server_user).search_conn(params).order('admins.updated_at desc').page(params[:page]).per(20)
  end

  def cash_form
    @log = @admin.admin_commission_logs.cash.new
    render layout: false
  end

  def cash
    @log = @admin.admin_commission_logs.cash.done.new
    if params[:commission].present?
      commission = @admin.admin_commission.present? ? @admin.admin_commission.commission : 0
      @log.errors.add(:commission, '提现金额不能小于0') if params[:commission].to_f * 100 <= 0
      @log.errors.add(:commission, '超过可用余额') if params[:commission].to_f * 100 > commission
    end
    if @log.errors.present?
      @flag = false
      return
    end
    admin_commission = AdminCommission.find_or_initialize_by admin: @admin
    @flag =  @log.update commission: -(params[:commission].to_f*100), desc: params[:desc], admin_commission: admin_commission
  end

  def set_admin
    @admin = Admin.find_by id: params[:id]
  end


end
