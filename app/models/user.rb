class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable
  has_many :orders
  has_many :addresses
  belongs_to :admin, optional: true
  has_many :share_orders, class_name: 'Order', foreign_key: :share_user_id
  belongs_to :company, optional: true
  has_one :user_commission
  has_many :user_commission_logs
  has_many :notifications
  acts_as_paranoid

  def get_gender
    case gender
    when 0
      '女'
    when 1
      '男'
    end
  end

  def set_user_info user_info
    self.nick_name = user_info['nickName']
    self.gender = user_info['gender']
    self.city = user_info['city']
    self.province = user_info['province']
    self.country = user_info['country']
    self.avatar_url = user_info['avatarUrl']
    self.save
    self
  end

  def wx_qrcode
    qrcode_path = "public/qrcode/#{self.id}.jpg"
    unless File.exist? qrcode_path
      unless File::directory? 'public/qrcode'
        Dir.mkdir("public/qrcode")
      end
      buffer = Wechat.api.wxa_get_wxacode_unlimit "share_token=#{self.id}"
      image_base64 = Base64.encode64(File.read(buffer))
      File.open qrcode_path, 'w+:ASCII-8BIT:utf-8' do |file|
        file.write Base64.decode64(image_base64)
      end
    end
    qrcode_path.gsub 'public/', ''
  end

  class << self
    def search_conn params
      users = self.all
      if params[:table_search].present?
        users = users.where('nick_name like ? or phone like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      if params[:type].present?
        if params[:type] == 'company'
          users = users.where.not(company_id: nil)
        elsif params[:type] == 'admin'
          users = users.where.not(admin_id: nil)
        end
      end
      users
    end

    def get_session code
      RestClient.get "https://api.weixin.qq.com/sns/jscode2session?appid=#{Wechat.api.access_token.appid}&secret=#{Wechat.api.access_token.secret}&js_code=#{code}&grant_type=authorization_code"
    end

    def init_by_web_code code
      # res = JSON.parse get_session(code).body
      res = Wechat.api.jscode2session(code)
      if res && res['openid']
        user = User.find_or_initialize_by open_id: res['openid']
        user.authentication_token ||= generate_authentication_token
        user.share_token ||= SecureRandom.uuid
        user.update session_token: res['session_key']
        user
      end
    end
  end

  private

  def self.generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
