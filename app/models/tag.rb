class Tag < ApplicationRecord
  has_ancestry cache_depth: true
  belongs_to :category
  belongs_to :tag_attachment, foreign_key: :attachment_id
  has_many :products

  validates_presence_of :name, :category_id, :attachment_id

  def self.search_conn params
    tags = self.all
    if params[:category_id].present?
      tags = tags.where category_id: params[:category_id]
    end
    if params[:table_search].present?
      tags = tags.where 'name like ?', "%#{params[:table_search]}%"
    end
    tags
  end

end
