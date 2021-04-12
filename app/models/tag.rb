class Tag < ApplicationRecord
  has_ancestry cache_depth: true
  belongs_to :category
  has_many :products

end
