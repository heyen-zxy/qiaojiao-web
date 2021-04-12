module V1
  module Entities
    class PublicMessage < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      #format_with(:parent) { |dt| instance.parent.name }
      expose :id
      expose :content
      expose :phone
      expose :show_name
      expose :image_path

      expose :attachments, using: V1::Entities::Attachment

      # product_category 是在rails的model中定义的关联，在这里可以直接用
      expose :message_type, using: V1::Entities::MessageType
      expose :updated_at do |instance, options|
        instance.updated_at.strftime "%m-%d %H:%M"
      end

      with_options(format_with: :timestamp) do
        expose :created_at
      end
    end
  end
end