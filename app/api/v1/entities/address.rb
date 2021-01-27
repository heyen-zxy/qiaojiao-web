require 'openssl'
require 'base64'
module V1
  module Entities
    class Address < Grape::Entity
      format_with(:timestamp) { |dt| dt.try :strftime, '%Y-%m-%d %H:%M:%S' }
      expose :id
      expose :name
      expose :phone
      expose :address_code
      expose :address_name
      expose :desc
      expose :user, using: V1::Entities::User
      with_options(format_with: :timestamp) do
        expose :created_at, documentation: { type: 'Timestamp' }
        expose :updated_at, documentation: { type: 'Timestamp' }
      end
    end
  end
end