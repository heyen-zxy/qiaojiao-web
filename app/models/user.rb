class User < ApplicationRecord
  has_many :orders
  has_many :addresses

  def get_gender
    case gender
    when 0
      '女'
    when 1
      '男'
    end
  end

  class << self
    def search_conn params
      users = self.all
      if params[:table_search].present?
        users = users.where('nick_name like ? or phone like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      users
    end
  end
end
