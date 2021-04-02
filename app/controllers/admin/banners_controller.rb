class Admin::BannersController < Admin::BaseController
  before_action :set_banner, only: [:edit, :update, :change_status, :destroy]
  before_action :set_uptoken, only: [:new, :edit, :create, :update]
  include ApplicationHelper
  def index
    params[:status] ||= 'on'
    @banners = Banner.search_conn(params).order('priority desc, status desc').page(params[:page]).per(20)
  end

  def new
    @banner = Banner.on.new
  end

  def create
    @banner = Banner.new
    if @banner.update banner_permit
      redirect_to admin_banners_path, notice: '添加成功'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @banner.update banner_permit
      redirect_to admin_banners_path, notice: '变更成功'
    else
      render :edit
    end
  end

  def change_status
    @banner.update status: params[:status]
  end

  def destroy
    if @banner.destroy
      redirect_to admin_banners_path, notice: '删除成功'
    end
  end

  private
  def set_banner
    @banner = Banner.find_by id: params[:id]
    redirect_to admin_banners_path, alert: '找不到数据' if @banner.blank?
  end

  def banner_permit
    params.require(:banner).permit(:attachment_id, :status, :priority, :product_id)
  end

  private

  def set_uptoken
    @uptoken = uptoken
  end

end
