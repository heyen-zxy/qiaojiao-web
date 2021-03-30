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
          categories = Category.where.not(ancestry: nil).order('updated_at desc')
          present categories, with: V1::Entities::Category
        end

        route_param :id do
          before do
            @category = Category.find_by id: params[:id]
            error!("找不到数据", 500) unless @category.present?
          end

          desc '分类商品'
          get 'products' do
            p @current_user, 11111
            present @category.products, with: V1::Entities::Product, user: @current_user
          end
        end
      end
    end
  end
end