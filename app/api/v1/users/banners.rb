module V1
  module Users
    class Banners < Grape::API
      resources 'banners' do
        desc '流动广告'
        get '/' do
          banners = Banner.on.joins(:product).where('products.status': :on).order('priority desc')
          present banners, with: V1::Entities::Banner
        end
      end
    end
  end
end