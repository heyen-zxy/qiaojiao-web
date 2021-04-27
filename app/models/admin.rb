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
  has_one :agent



  belongs_to :server_agent, foreign_key: :agent_id, class_name: 'Agent', optional: true

  acts_as_paranoid

  belongs_to :role, optional: true

  attr_accessor :old_password

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

  def server_users
    admins = Admin.joins(:role).where('roles.tag': 'server_user')
    if role? :super_admin
      admins
    elsif (role? :agent) && agent.present?
      agent.server_users
    else
      admins.where('1= -1')
    end
  end

  def server_users_select
    server_users.collect{|admin| ["#{admin.name}-#{admin.phone}", admin.id]}
  end

  def show_orders
    if role? :super_admin
      Order.all
    elsif (role? :agent) && agent&.county.present?
      Order.joins(:address, {order_norms: :product}).where('addresses.address_code': agent.county, 'products.product_type': '服务')
    else
      Order.where('1= -1')
    end
  end

  def in_payments

    if role? :super_admin
      InPayment.all
    elsif (role? :agent) && agent&.county.present?
      InPayment.joins(order: [:address, {order_norms: :product}]).where('addresses.address_code': agent.county, 'products.product_type': '服务')
    else
      InPayment.where('1= -1')
    end
  end
end
