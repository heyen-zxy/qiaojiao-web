module V1
  module Entities
    class Order < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      expose :id
      expose :no
      expose :user, using: V1::Entities::User
      expose :order_norms, using: V1::Entities::OrderNorm
      expose :address, using: V1::Entities::Address
      expose :status
      expose :get_status
      expose :view_amount
      expose :desc
      expose :view_commission
      expose :admin_id
      expose :attachments, using: V1::Entities::Attachment
      with_options(format_with: :timestamp) do
        expose :payment_at, documentation: { type: 'Timestamp' }
        expose :created_at, documentation: { type: 'Timestamp' }
        expose :updated_at, documentation: { type: 'Timestamp' }
      end
    end
  end
end