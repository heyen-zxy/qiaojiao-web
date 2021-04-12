module V1
  module Users
    class Messages < Grape::API
      helpers UserLoginHelper
      include Grape::Kaminari
      resources 'messages' do
        desc '消息列表'
        params do
          optional :message_type_id, type: Integer, desc: '消息类型'
          optional :per_page, type: Integer, desc: '每页数据个数', default: 10
          optional :page, type: Integer, desc: '页码'
        end
        get '/' do
          messages = PublicMessage.all.order('updated_at desc')
          if params[:message_type_id].present? && params[:message_type_id].to_i > 0
            messages = messages.where message_type_id: params[:message_type_id]
          end
          present paginate(messages), with: V1::Entities::PublicMessage
        end

        desc '消息类型列表'
        get 'types' do
          types = MessageType.all
          present types, with: V1::Entities::MessageType
        end
      end
    end
  end
end