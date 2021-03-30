class Company < ApplicationRecord
  acts_as_paranoid
  validates_presence_of :name, :user_name, :address, :phone
end
