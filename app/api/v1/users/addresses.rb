module V1
  module Users
    class Addresses < Grape::API
      helpers UserLoginHelper
      resources 'addresses' do
        before do
          authenticate!
        end

        desc '地址列表'
        get '/' do
          addresses = @current_user.addresses.order('updated_at desc')
          present addresses, with: V1::Entities::Address
        end

        desc '默认选择地址'
        get 'default' do
          @address = @current_user.addresses.where(default: true).first
          @address = @current_user.addresses.last unless @address.present?
          present @address, with: V1::Entities::Address
        end

        desc '创建新地址'
        params do
          requires :name,     type: String, desc: '名字'
          requires :phone,     type: String, desc: '姓名'
          requires :address_code,     type: String, desc: '地址'
          requires :desc,     type: String, desc: '详细地址'
          optional :address_type,     type: String, desc: '地址tag'
          optional :default,     type: String, desc: '详细地址'
        end
        post '/' do
          params[:default] = params[:default] == 'true'
          @address = @current_user.addresses.create params
          present Address.first, with: V1::Entities::Address
        end

        route_param :id do
          before do
            @address = @current_user.addresses.find_by id: params[:id]
            error!("找不到数据", 500) unless @address.present?
          end

          desc '编辑地址'
          params do
            requires :name,     type: String, desc: '名字'
            requires :phone,     type: String, desc: '姓名'
            requires :address_code,     type: String, desc: '地址'
            requires :desc,     type: String, desc: '详细地址'
            optional :address_type,     type: String, desc: '地址tag'
            optional :default,     type: String, desc: '详细地址'
          end
          put '/' do
            params[:default] = params[:default] == 'true'
            @address.update params
            present Address.first, with: V1::Entities::Address
          end

          desc '地址详情'
          get '/' do
            present @address, with: V1::Entities::Address
          end
        end
      end
    end
  end
end