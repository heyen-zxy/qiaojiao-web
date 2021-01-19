module Crud
  extend ActiveSupport::Concern
  included do
    before_action :model_permit
    def index
      p model_scope, 111
    end


  end
end