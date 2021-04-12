class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates_presence_of :phone, :name
  validates_uniqueness_of :phone
  has_one :user
  has_many :orders
  has_one :admin_commission
  has_many :admin_commission_logs

  acts_as_paranoid

  belongs_to :role, optional: true

  class << self
    def search_conn params
      admins = self.all
      if params[:table_search].present?
        admins = admins.where('admins.name like ? or phone like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%")
      end
      admins
    end

    def server_users
      self.joins(:role).where('roles.tag': 'server_user')
    end
  end

  def role? role_name
    self.role&.tag.to_s == role_name.to_s
  end

  def self.server_users
    Admin.joins(:role).where('roles.tag': 'server_user')
  end

  def self.server_users_select
    server_users.collect{|admin| ["#{admin.name}-#{admin.phone}", admin.id]}
  end
end
