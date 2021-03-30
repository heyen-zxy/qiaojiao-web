class Category < ApplicationRecord
  acts_as_paranoid
  has_many :products
  has_ancestry

  default_scope {order('sort_num desc')}

  def on_products
    products.on
  end

  class << self
    def select_options
      Category.where.not(ancestry: nil).collect{|category| [category.name, category.id]}
    end
  end
end
