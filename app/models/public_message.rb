class PublicMessage < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :message_type

  validates_presence_of :content, :message_type_id

  has_and_belongs_to_many :attachments, join_table: 'model_attachments', foreign_key:  :model_id, class_name: 'MessageAttachment', association_foreign_key: :attachment_id

  enum status: {
      on: '生效',
      off: '无效'
  }

  def self.status_select
    statuses.collect{|key, value| [value, key]}
  end

  def self.search_conn params
    public_messages = self.all
    if params[:table_search].present?
      public_messages = public_messages.where('name like ? or phone like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
    end
    public_messages
  end

  def image_path
    if user.present?
      user.avatar_url
    end
  end

  def show_name
    name.present? ? name : '佳匠服务'
  end

end
