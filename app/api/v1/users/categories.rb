module V1
  module Users
    class Categories < Grape::API
      resources 'categories' do

        desc '分类列表'
        get '/' do
          categories = Category.roots.order('updated_at desc')
          present categories, with: V1::Entities::CategoryTree
        end

        route_param :id do
          before do
            @category = Category.find_by id: params[:id]
            error!("找不到数据", 500) unless @category.present?
          end

          desc '分类商品'
          get 'products' do
            present @category.children.includes(:products).where('products.id is not null').references(:all), with: V1::Entities::CategoryProduct
          end
        end
      end
    end
  end
end