class Admin::ProductsController < Admin::BaseController
  include Crud
  def model_scope
    Product
  end

  def model_permit

  end

end
