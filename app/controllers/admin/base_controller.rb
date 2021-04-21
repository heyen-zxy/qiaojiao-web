class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!
  before_action :cancan_ability

  def current_user
    current_admin
  end

  def cancan_ability
    unless can? controller_name.to_sym, action_name.to_sym
      redirect_to root_path, alert: '无权限'
    end
  end
end
