module V1
  module Entities
    class Product < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      expose :id
      expose :name
      expose :product_type
      expose :status
      expose :get_status
      expose :price
      expose :no
      expose :sale
      expose :amount
      expose :view_commission do |instance, options|
        if options[:user].present?
          instance.user_commission options[:user]
        end
      end
      expose :desc do |instance, options|
        instance.desc.to_s
      end

      # product_category 是在rails的model中定义的关联，在这里可以直接用
      expose :category, using: V1::Entities::Category
      expose :norms, using: V1::Entities::Norm
      expose :attachments, using: V1::Entities::Attachment

      with_options(format_with: :timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end