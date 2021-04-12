module V1
  module Users
    class Categories < Grape::API
      helpers V1::Users::UserLoginHelper
      resources 'categories' do
        before do
          current_user
        end
        desc '分类列表'
        get '/' do
          categories = Category.where.not(ancestry_depth: 1).order('updated_at desc')
          present categories, with: V1::Entities::Category
        end

        route_param :id do
          before do
            @category = Category.find_by id: params[:id]
            error!("找不到数据", 500) unless @category.present?
          end

          desc '分类商品'
          params do
            optional :tag_id, type: Integer,  desc: '品牌id'
          end
          get 'products' do
            products = @category.products.on
            products = @category.products.on.where tag_id: params[:tag_id] if params[:tag_id].present?
            present products, with: V1::Entities::Product, user: @current_user
          end

          desc '品牌'
          get 'tags' do
            present @category.tags, with: V1::Entities::Tag
          end
        end
      end
    end
  end
end