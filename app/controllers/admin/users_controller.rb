class Admin::UsersController < Admin::BaseController
  # before_action :set_user, only: [:show, :set_desc]

  def index
    @users = User.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end

  # private
  # def set_user
  #   @user = User.find_by id: params[:id]
  #   redirect_to admin_users_path, alert: '找不到数据' if @user.blank?
  # end

end
