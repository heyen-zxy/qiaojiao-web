class Admin::TagsController < Admin::BaseController
  before_action :set_tag, only: [:edit, :update, :change_status, :destroy]
  before_action :set_uptoken, only: [:new, :edit, :create, :update]
  include ApplicationHelper
  def index
    @tags = Tag.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new
    if @tag.update tag_permit
      redirect_to admin_tags_path, notice: '添加成功'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @tag.update tag_permit
      redirect_to admin_tags_path, notice: '变更成功'
    else
      render :edit
    end
  end


  def destroy
    if @tag.products.present?
      redirect_to admin_tags_path, alert: '该分类下有商品服务，不可删除'
      return
    end
    if @tag.destroy
      redirect_to admin_tags_path, notice: '删除成功'
    end
  end

  private
  def set_tag
    @tag = Tag.find_by id: params[:id]
    redirect_to admin_tags_path, alert: '找不到数据' if @tag.blank?
  end

  def tag_permit
    params.require(:tag).permit(:attachment_id, :name, :category_id)
  end

  private

  def set_uptoken
    @uptoken = uptoken
  end

end
