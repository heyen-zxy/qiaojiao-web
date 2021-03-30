module V1
  module Users
    class Orders < Grape::API
      helpers UserLoginHelper
      helpers QiniuHelper
      resources 'orders' do
        before do
          authenticate!
        end

        route_param :id do
          before do
            @order = @current_user.orders.find_by id: params[:id]
            @order = @current_user.share_orders.find_by id: params[:id] unless @order.present?
            @order = @current_user.admin&.orders.find_by id: params[:id] unless @order.present?
            error!("找不到数据", 500) unless @order.present?
          end

          desc '订单详情'
          get '/' do
            present @order, with: V1::Entities::Order
          end

          desc '微信下单支付'
          params do
            optional :address_id, type: Float, desc: '地址'
            optional :desc, type: String, desc: '备注'
          end
          post 'wx_pay' do
            @order.address_id = params[:address_id] if params[:address_id].present? && @order.address_id.blank?
            @order.desc = params[:desc] if params[:desc].present? && @order.desc.blank?
            @order.save
            payment = InPayment.create order: @order, user: @current_user, amount: @order.amount
            payment.js_pay_req
          end

          desc '完成服务'
          post 'server_order' do
            @order.do_server!
            p @order.errors, 111111111
            present @order, with: V1::Entities::Order
          end

          desc '上传图片'
          post 'server_files' do
            @uptoken = uptoken
            if params[:server][:tempfile].present?
              file_name = params[:server][:filename]

              code, result, response_headers = ::Qiniu::Storage.upload_with_token_2(
                  @uptoken,
                  params[:server][:tempfile],
                  SecureRandom.uuid  + '.' + file_name.split('.').last,
                  nil,
                  bucket: 'qiaojiangyoujia'
              )
              file_path = result['key']
              @attachment = ServerAttachment.create file_name: params[:server][:filename], file_path: file_path
              @order.attachments.push @attachment
            end
            present @order, with: V1::Entities::Order
          end
        end
      end
    end
  end
end