class Resource < ApplicationRecord
  validates_presence_of :name, :target, :action
  has_and_belongs_to_many :roles, join_table: 'role_resources'
end
