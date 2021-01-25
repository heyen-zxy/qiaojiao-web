class Product < ApplicationRecord
  validates_presence_of :name, :category_id, :product_type, :status, :attachments, :norms
  validates :commission,  inclusion: {in: 1..9999999999 }, if: Proc.new { |product| product.commission.present? }
  has_many :norms


  has_and_belongs_to_many :attachments, join_table: 'model_attachments', foreign_key:  :model_id, class_name: 'ProductAttachment', association_foreign_key: :attachment_id
  enum status: {
      on: '上架中',
      off: '下架中'
  }

  enum product_type: {
      good: '商品',
      service: '服务'
  }

  def view_commission
    commission.to_f / 100
  end

  class << self
    def search_conn params
      products = self.all
    end

    def type_select
      product_types.collect{|key, value| [value, key]}
    end

    def status_select
      statuses.collect{|key, value| [value, key]}
    end
  end
end
