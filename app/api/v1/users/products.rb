module V1
  module Users
    class Products < Grape::API
      helpers V1::Users::UserLoginHelper
      include Grape::Kaminari

      resources 'products' do
        desc '商品列表'
        params do
          optional :page,     type: Integer, default: 1, desc: '页码'
          optional :per_page, type: Integer, desc: '每页数据个数', default: 10
          optional :product_type, type: String, desc: '类型 good service'
          optional :table_search, type: String, desc: '检索'
          optional :low_price, type: Float, desc: '最低价格'
          optional :high_price, type: Float, desc: '最高价格'
          optional :norm_id, type: Integer, desc: '规格id'
        end
        get '/' do
          params[:category_id] = JSON.parse params[:category_ids] if params[:category_ids].present?
          products = Product.on.search_conn(params)
          present paginate(products), with: V1::Entities::Product, user: @current_user
        end

        desc '根据norm_id'

        desc '推荐商品'
        get 'recommend' do
          products = Product.on.order('sale asc').last(20).sample(10)
          present products, with: V1::Entities::Product, user: @current_user
        end

        route_param :id do
          before do
            @product = Product.on.find_by id: params[:id]
            error!("找不到数据", 500) unless @product.present?
          end

          desc '商品详情'
          get '/' do
            present @product, with: V1::Entities::Product, user: @current_user
          end
        end
      end
    end
  end
end