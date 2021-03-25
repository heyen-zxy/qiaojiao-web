class Company < ApplicationRecord
  validates_presence_of :name, :user_name, :address, :phone
end
