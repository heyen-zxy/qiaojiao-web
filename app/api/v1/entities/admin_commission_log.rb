module V1
  module Entities
    class AdminCommissionLog < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      expose :id
      expose :view_commission
      expose :view_commission_before
      expose :view_commission_after
      expose :get_commission_type
      with_options(format_with: :timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
end