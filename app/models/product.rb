class Product < ApplicationRecord
  validates_presence_of :name, :category_id, :product_type, :status, :attachments, :norms
  validates :commission,  inclusion: {in: 1..9999999999 }, if: Proc.new { |product| product.commission.present? }
  has_many :norms
  after_create :set_product_no


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

  def get_status
    Product::statuses[self.status.to_sym]
  end

  def get_product_type
    Product::product_types[self.product_type.to_sym]
  end

  def set_product_no
    self.no = self.encode_token unless self.no.present?
    self.save
  end

  def price
    prices = norms.collect{|norm| norm.view_price}
    if prices.size > 1
      "#{prices.min} ~ #{prices.max}"
    else
      prices.first
    end
  end

  def encode_token
    val     = id + 3624241231234
    hashids = Hashids.new("qiaojiaoyoujia", 20)
    hashids.encode val
  end

  def set_sale number, amount
    self.update sale: self.sale + number, amount: self.amount + amount
  end

  class << self
    def search_conn params
      products = self.all
      if params[:status].present?
        products = products.where status: params[:status]
      end
      if params[:category_id].present?
        products = products.where category_id: params[:category_id]
      end
      if params[:product_type].present?
        products = products.where product_type: params[:product_type]
      end
      if params[:name].present?
        products = products.where('name like ? or no like ?', "%#{params[:name]}%", "%#{params[:name]}%")
      end
      products
    end

    def type_select
      product_types.collect{|key, value| [value, key]}
    end

    def status_select
      statuses.collect{|key, value| [value, key]}
    end

    def decode_token token
      hashids    = Hashids.new("qiaojiaoyoujia", 20)
      hash_array = hashids.decode token
      hash_array.first - 3624241231234 rescue nil
    end
  end


end
