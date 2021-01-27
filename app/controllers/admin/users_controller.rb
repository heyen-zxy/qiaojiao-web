class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:admin, :set_admin]

  def index
    @users = User.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end

  def admin
    render layout: false
  end

  def set_admin
    @user.update admin_id: params[:admin_id]
  end

  private
  def set_user
    @user = User.find_by id: params[:id]
    redirect_to admin_users_path, alert: '找不到数据' if @user.blank?
  end

end
