class Banner < ApplicationRecord
  belongs_to :product
  belongs_to :banner_attachment, foreign_key: :attachment_id

  validates_presence_of :product_id, :status, :priority

  enum status: {
      on: '生效',
      off: '无效'
  }

  def self.status_select
    statuses.collect{|key, value| [value, key]}
  end

  def self.search_conn params
    banners = self.joins(:product).all
    if params[:table_search].present?
      banners = banners.where('products.name like ? or products.no like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
    end
    banners
  end

  def get_status
    Banner::statuses[self.status.to_sym]
  end

end
