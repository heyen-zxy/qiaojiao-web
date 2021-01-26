class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:edit, :update, :change_status]
  def index
    params[:status] ||= 'on'
    @products = Product.search_conn(params).order('updated_at desc').page(params[:page]).per(20)
  end

  def new
    @product = Product.off.new
  end

  def create
    @product = Product.new
    prices = params[:new_prices]
    norms = []
    if params[:new_norms].present?
      params[:new_norms].each_with_index do |norm, index|
        next if norm.blank? && prices[index].blank?
        prices[index]  = (prices[index].to_f*100).to_i if prices[index].present?
        norm = Norm.new name: norm, price: prices[index]
        norms << norm
      end
    end

    @product.norms = norms
    @product.attachment_ids = params[:attachment_ids].split(',')
    @product.commission = params[:product][:commission].to_f * 100 if params[:product][:commission].present?
    if @product.update product_permit
      redirect_to admin_products_path, notice: '变更成功'
    else
      render :new
    end
  end

  def edit

  end

  def update
    prices = params[:new_prices]
    norms = []
    #新建规格
    if params[:new_norms].present?
      params[:new_norms].each_with_index do |name, index|
        next if name.blank? && prices[index].blank?
        prices[index]  = (prices[index].to_f*100).to_i if prices[index].present?
        norm = Norm.new name: name, price: prices[index]
        norms << norm
      end
    end

    #编辑规格
    prices = params[:prices]
    if params[:norms].present?
      params[:norms].each do |key, value|
        norm = Norm.find_by id: key
        next if norm.blank?
        prices[key]  = (prices[key].to_f*100).to_i if prices[key].present?
        norm.attributes =  {name: value, price: prices[key]}
        norms << norm
      end
    end
    @product.norms = norms
    @product.attachment_ids = params[:attachment_ids].split(',')
    @product.commission = params[:product][:commission].to_f * 100 if params[:product][:commission].present?
    if @product.update product_permit
      redirect_to admin_products_path, notice: '添加成功'
    else
      render :edit
    end
  end

  def change_status
    @product.update status: params[:status]
  end

  private
  def set_product
    @product = Product.find_by id: params[:id]
    redirect_to admin_products_path, alert: '找不到数据' if @product.blank?
  end

  def product_permit
    params.require(:product).permit(:name, :category_id, :status, :product_type, :desc)
  end

end
