class Role < ApplicationRecord
  validates_presence_of :name, :tag
  has_and_belongs_to_many :resources, join_table: 'role_resources'
end
