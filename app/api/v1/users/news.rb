module V1
  module Users
    class News < Grape::API
      resources 'news' do
        desc '流动广告'
        get '/' do
          present ::News.on, with: V1::Entities::News
        end
      end
    end
  end
end