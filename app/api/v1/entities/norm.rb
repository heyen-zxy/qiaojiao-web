module V1
  module Entities
    class Norm < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      expose :id
      expose :name
      expose :price do |instance, options|
        instance.view_price
      end
      with_options(format_with: :timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end