module V1
  module Entities
    class User < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      expose :id
      expose :phone
      expose :country
      expose :province
      expose :city
      expose :avatar_url do |instance, options|
        instance.avatar_url
      end
      expose :admin_id
      expose :nick_name
      expose :gender
      # product_category 是在rails的model中定义的关联，在这里可以直接用
      #expose :role, using: V1::Entities::Role

      with_options(format_with: :timestamp) do
        expose :created_at, documentation: { type: 'Timestamp' }
        expose :updated_at, documentation: { type: 'Timestamp' }
      end
    end
  end
end