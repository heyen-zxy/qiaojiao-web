class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable
  has_many :orders
  has_many :addresses
  belongs_to :admin, optional: true

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

    def init_by_web_code code, type
      res = Wechat.api(type).web_access_token code
      if res && res['openid']
        init_by_web_session res['access_token'], res['openid'], type
      end
    end

    def init_by_web_session access_token, openid, type
      user_info = Wechat.api(type).web_userinfo access_token, openid
      if user_info['unionid']
        user = User.find_or_initialize_by unionid: user_info['unionid']
        if type.to_s == 'default'
          user.web_session_token = access_token
          user.web_openid = user_info['openid']
        end

        if type.to_s == 'app'
          user.app_session_token = access_token
          user.app_openid = user_info['openid']
        end

        user.nick_name = user_info['nickname']
        user.gender = user_info['sex']
        user.city = user_info['city']
        user.province = user_info['province']
        user.country = user_info['country']
        user.avatar_url = user_info['headimgurl']
        user.save
        user
      end
    end
  end
end
