class Product < ApplicationRecord
  validates_presence_of :name, :category_id, :product_type, :status, :attachments, :norms, :main_attachment_id
  #validates :commission,  inclusion: {in: 0..9999999999 }, if: Proc.new { |product| product.commission.present? }
  has_many :norms
  after_create :set_product_no
  belongs_to :category

  acts_as_paranoid

  belongs_to :main_attachment, foreign_key: :main_attachment_id, class_name: 'ProductAttachment', optional: true

  has_and_belongs_to_many :attachments, join_table: 'model_attachments', foreign_key:  :model_id, class_name: 'ProductAttachment', association_foreign_key: :attachment_id
  enum status: {
      on: '上架中',
      off: '下架中'
  }

  enum product_type: {
      good: '商品',
      service: '服务'
  }

  def user_commission user
    if user.admin.present?
      if high_commission.to_i > 0
        high_commission.to_i
      else
        commission.to_i
      end
    else
      commission.to_i
    end
  end

  def view_user_commission user
    comm = if user.admin.present?
      if high_commission.to_i > 0
        high_commission.to_i
      else
        commission.to_i
      end
    else
      commission.to_i
           end
    comm / 100.0
  end

  def view_commission
    commission.to_f / 100
  end

  def view_high_commission
    high_commission.to_f / 100
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
      "#{prices.min}~#{prices.max}"
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
      products = self.includes(:norms).references :all
      if params[:status].present?
        products = products.where status: params[:status]
      end
      if params[:category_id].present?
        p params[:category_id], 11111
        products = products.where category_id: params[:category_id]
      end
      if params[:product_type].present?
        products = products.where product_type: params[:product_type]
      end
      if params[:table_search].present?
        products = products.where('products.name like ? or no like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      if params[:low_price].present?
        products = products.where('norms.price >= ?', params[:low_price] * 100)
      end
      if params[:high_price].present?
        products = products.where('norms.price <= ?', params[:high_price] * 100)
      end
      if params[:norm_id].present?
        products = products.where('norms.id': params[:norm_id])
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
