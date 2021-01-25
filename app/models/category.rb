class Category < ApplicationRecord
  has_ancestry

  class << self
    def select_options
      Category.where.not(ancestry: nil).collect{|category| [category.name, category.id]}
    end
  end
end
