class News < ApplicationRecord
  validates_presence_of :content
  enum status: {
      on: '生效',
      off: '无效'
  }

  def self.status_select
    statuses.collect{|key, value| [value, key]}
  end

  def get_status
    News::statuses[self.status.to_sym]
  end
end
