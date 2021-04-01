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
            {authentication_token: user.authentication_token, share_token: user.id}
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

        desc '个人数据', headers: {
            "X-Auth-Token" => {
                description: "登录token",
                required: false
            }
        }
        get 'my' do
          data = {
              wait_order: @current_user.orders.where(status: 'wait').size,
              paid_order: @current_user.orders.where(status: 'paid').size,
              served_order: @current_user.orders.where(status: 'served').size,
              share_order: @current_user.user_commission&.share_order || 0,
              commission: @current_user.user_commission&.view_commission || 0,
              commission_wait: @current_user.user_commission&.view_commission_wait || 0,
              commission_paid: @current_user.user_commission&.view_commission_paid || 0
          }
          if @current_user.admin.present?
            data.merge!({
                           admin_server_order: @current_user.admin.orders.size,
                           admin_wait_server_order: @current_user.admin.orders.where(status: 'paid').size,
                           admin_served_order: @current_user.admin.orders.where(status: 'served').size
                       })
          end
          data
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
          optional :status,     type: String, desc: '状态'
        end
        get 'orders' do
          orders = @current_user.orders.order('updated_at desc')
          if params[:status].present?
            orders = orders.where(status: params[:status])
          end
          present paginate(orders), with: V1::Entities::Order
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
          optional :status,     type: String, desc: '状态'

        end
        get 'server_orders' do
          if @current_user.admin.present?
            orders = @current_user.admin.orders.order('updated_at desc')
            if params[:status].present?
              orders = orders.where(status: params[:status])
            end
            present paginate(orders), with: V1::Entities::Order
          end
        end

        desc '我分享的订单', headers: {
            "X-Auth-Token" => {
                description: "登录token",
                required: false
            }
        }
        params do
          optional :page,     type: Integer, default: 1, desc: '页码'
          optional :per_page, type: Integer, desc: '每页数据个数', default: 10
        end
        get 'share_orders' do
          if @current_user.admin.present?
            orders = @current_user.share_orders.where(status: 'served').order('updated_at desc')
            present paginate(orders), with: V1::Entities::Order, user: @current_user
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