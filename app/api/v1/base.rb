module V1
  class Base < Grape::API
    version 'v1', using: :path
    mount V1::Users::Users
    mount V1::Users::Categories
    mount V1::Users::Qiniu
    mount V1::Users::Products
    mount V1::Users::Banners
    mount V1::Users::Addresses
    mount V1::Users::Orders
    mount V1::Users::News
    mount V1::Users::Messages

    mount V1::Wechat

    add_swagger_documentation(
        :api_version => "api/v1",
        hide_documentation_path: true,
        hide_format: true
    )
  end
end
