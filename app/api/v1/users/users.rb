module V1
  module Users
    class Users < Grape::API
      helpers UserLoginHelper
      helpers QiniuHelper
      include Grape::Kaminari
      resources 'users' do
        desc '小程序登录'
        params do
          requires :code, type: String, desc: '微信code'
        end
        post "/wx_login" do
          user = User.init_by_web_code params[:code]
          if user.present? && user.is_a?(User) && user.id.present?
            {authentication_token: user.authentication_token, share_token: user.share_token}
          end
        end

        before do
          authenticate!
        end

        desc '设置用户信息', headers: {
            "X-Auth-Token" => {
                description: "登录token",
                required: false
            }
        }
        post 'set_user_info' do
          @current_user.set_user_info params
          present @current_user, with: V1::Entities::User
        end


        desc '个人详情', headers: {
                "X-Auth-Token" => {
                    description: "登录token",
                    required: false
                }
            }
        get 'me' do
          present @current_user, with: V1::Entities::User
        end

        desc '我的订单', headers: {
            "X-Auth-Token" => {
                description: "登录token",
                required: false
            }
        }
        params do
          optional :page,     type: Integer, default: 1, desc: '页码'
          optional :per_page, type: Integer, desc: '每页数据个数', default: 10
        end
        get 'orders' do
          present paginate(@current_user.orders), with: V1::Entities::Order
        end

        desc '我负责的订单', headers: {
            "X-Auth-Token" => {
                description: "登录token",
                required: false
            }
        }
        params do
          optional :page,     type: Integer, default: 1, desc: '页码'
          optional :per_page, type: Integer, desc: '每页数据个数', default: 10
        end
        get 'server_orders' do
          if @current_user.admin.present?
            present paginate(@current_user.admin.orders), with: V1::Entities::Order
          end
        end

        desc '下单',  headers: {
            "X-Auth-Token" => {
                description: "登录token",
                required: false
            }
        }
        params do
          requires :norm_array,     type: String, desc: "商品信息[{规格id ， 数量}]#{[{id: 1, number: 2}, {id: 2, number: 2}, {id: 13, norm: {id: 13, number: 1}}, {id: 12, norm: {id: 11, number: 1}}].to_json}"
        end
        post 'apply_orders' do
          order = Order.save_orders @current_user, params
          if order.id.present?
            present order, with: V1::Entities::Order
          else
            {message: order.errors, status: 'error'}
          end

        end

      end
    end
  end

end