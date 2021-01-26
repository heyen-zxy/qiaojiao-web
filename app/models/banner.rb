class Banner < ApplicationRecord
  belongs_to :product
  belongs_to :banner_attachment, foreign_key: :attachment_id

  enum status: {
      on: '生效',
      off: '无效'
  }

  def self.status_select
    statuses.collect{|key, value| [value, key]}
  end

  def get_status
    Banner::statuses[self.status.to_sym]
  end

end
