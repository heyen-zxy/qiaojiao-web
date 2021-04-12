class Admin::AdminCommissionLogsController < Admin::BaseController
  def index
    @logs = AdminCommissionLog.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end
end
