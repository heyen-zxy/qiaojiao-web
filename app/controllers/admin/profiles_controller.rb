class Admin::ProfilesController < Admin::BaseController
  before_action :set_admin
  def edit

  end

  def update

    if @admin.valid_password? admin_permit[:old_password]
      if @admin.update password: admin_permit[:password]
        redirect_to root_path
      else
        render :edit
      end
    else
      @admin.errors.add :old_password, '密码错误'
      render :edit
    end
  end

  def admin_permit
    params.require(:admin).permit(:old_password, :password)
  end

  def set_admin
    @admin = current_admin
  end
end
