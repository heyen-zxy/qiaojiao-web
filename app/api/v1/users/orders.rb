module V1
  module Users
    class Orders < Grape::API
      helpers UserLoginHelper
      resources 'orders' do
        before do
          authenticate!
        end

        route_param :id do
          before do
            p params[:id]
            @order = @current_user.orders.find_by id: params[:id]
            error!("找不到数据", 500) unless @order.present?
          end

          desc '商品详情'
          get '/' do
            present @order, with: V1::Entities::Order
          end

          desc '微信下单支付'
          post 'wx_pay' do
            pay_params = {
                body: '佳匠服务',
                out_trade_no: @order.no,
                total_fee: 1, #@order.amount,
                spbill_create_ip: '127.0.0.1',
                notify_url: 'https://qiaojiang.mynatapp.cc/wxpay_notify',
                trade_type: 'JSAPI', # could be "JSAPI", "NATIVE" or "APP",
                openid: @order.user.open_id # required when trade_type is `JSAPI`
            }
            r = WxPay::Service.invoke_unifiedorder pay_params
              #WxPay::Service.generate_js_pay_req r
          end
        end
      end
    end
  end
end