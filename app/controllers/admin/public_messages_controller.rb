class Admin::PublicMessagesController < Admin::BaseController
  before_action :set_public_message, only: [:edit, :update, :change_status, :destroy]
  before_action :set_uptoken, only: [:new, :edit, :create, :update]
  include ApplicationHelper
  def index
    params[:status] ||= 'on'
    @public_messages = PublicMessage.search_conn(params).page(params[:page]).per(20)
  end

  def new
    @public_message = PublicMessage.on.new
  end

  def create
    p params[:public_message][:attachment_ids], 111
    p params[:public_message][:attachment_ids].to_s.split(','), 2222

    @public_message = PublicMessage.new
    @public_message.attachment_ids = params[:public_message][:attachment_ids].to_s.split(',')
    if @public_message.update public_message_permit
      redirect_to admin_public_messages_path, notice: '添加成功'
    else
      render :new
    end
  end

  def edit

  end

  def update
    @public_message.attachment_ids = params[:public_message][:attachment_ids].to_s.split(',')
    if @public_message.update public_message_permit
      redirect_to admin_public_messages_path, notice: '变更成功'
    else
      render :edit
    end
  end

  def destroy
    if @banner.destroy
      redirect_to admin_banners_path, notice: '删除成功'
    end
  end

  private
  def set_public_message
    @public_message = PublicMessage.find_by id: params[:id]
    redirect_to admin_public_messages_path, alert: '找不到数据' if @public_message.blank?
  end

  def public_message_permit
    params.require(:public_message).permit(:status, :user_id, :phone, :name, :valid_days, :content, :message_type_id)
  end

  private

  def set_uptoken
    @uptoken = uptoken
  end
end
