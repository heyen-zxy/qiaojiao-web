class Admin::UserCommissionLogsController < Admin::BaseController
  def index
    @logs = UserCommissionLog.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end
end
