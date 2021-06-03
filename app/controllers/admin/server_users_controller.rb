class Admin::ServerUsersController < Admin::BaseController
  before_action :set_admin, only: [:adjust, :adjust_form, :cash, :cash_form, :agent, :set_agent]
  def index
    all_admins = current_admin.server_users.joins(:role, :admin_commission).where('roles.tag': :server_user)
    @amount = all_admins.sum('admin_commissions.commission_wait') / 100.0
    @admins = all_admins.search_conn(params).order('admins.updated_at desc').page(params[:page]).per(20)
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

  def adjust_form
    @log = @admin.admin_commission_logs.adjust.new
    render layout: false
  end

  def adjust
    @log = @admin.admin_commission_logs.adjust.done.new
    if params[:commission].present?
      commission = @admin.admin_commission.present? ? @admin.admin_commission.commission : 0
      @log.errors.add(:commission, '不能为0') if params[:commission].to_f * 100 == 0
      @log.errors.add(:commission, '超过可调整金额') if (params[:commission].to_f * 100 + commission) < 0
    end
    if @log.errors.present?
      @flag = false
      return
    end
    admin_commission = AdminCommission.find_or_initialize_by admin: @admin
    @flag =  @log.update commission: params[:commission].to_f*100, desc: params[:desc], admin_commission: admin_commission
  end

  def agent
    render layout: false
  end

  def set_agent
    @admin.update agent_id: params[:agent_id]
  end

  def set_admin
    @admin = current_admin.server_users.find_by id: params[:id]
  end


end
