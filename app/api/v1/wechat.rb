module V1
  class Wechat < Grape::API
    format :xml
    content_type :xml, "text/xml"
    resources 'wechat' do
      desc '微信订单支付结果'
      post 'wxpay_notify' do
        result = params["xml"]
        p result, result['out_trade_no'], 1111111
        order = Order.find_by no: result['out_trade_no']['__content__']
        if order.present?
          order.current_payment.times_order_query
        end
        status 200
        {return_code: "SUCCESS"}
      end
    end
  end
end
