class Admin::NewsController < Admin::BaseController
  before_action :set_news, only: [:edit, :update, :change_status, :destroy]
  def index
    params[:status] ||= 'on'
    @news = News.order('created_at desc').page(params[:page]).per(20)
  end

  def new
    @news = News.on.new
  end

  def create
    @news = News.new
    if @news.update news_permit
      redirect_to admin_news_index_path, notice: '添加成功'
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @news.update news_permit
      redirect_to admin_news_index_path, notice: '变更成功'
    else
      render :edit
    end
  end

  def change_status
    @news.update status: params[:status]
  end

  def destroy
    if @news.destroy
      redirect_to admin_news_index_path, notice: '删除成功'
    end
  end

  private
  def set_news
    @news = News.find_by id: params[:id]
    redirect_to admin_news_index_path, alert: '找不到数据' if @news.blank?
  end

  def news_permit
    params.require(:news).permit(:content, :status)
  end

end
