class Admin::AdminCommissionLogsController < Admin::BaseController
  def index
    admin_ids = current_admin.server_users.pluck :id
    @logs = AdminCommissionLog.where(admin_id: admin_ids).search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end
end
