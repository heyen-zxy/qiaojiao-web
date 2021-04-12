module V1
  module Entities
    class Tag < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      #format_with(:parent) { |dt| instance.parent.name }
      expose :id
      expose :name

      with_options(format_with: :timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end