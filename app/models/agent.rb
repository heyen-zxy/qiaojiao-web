class Agent < ApplicationRecord

  belongs_to :admin
  has_many :server_users, foreign_key: :agent_id, class_name: 'Admin'

  validates_presence_of :admin_id, :phone, :company_name, :name, :province, :city, :county

  def self.search_conn params
    agents = self.all
    if params[:table_search].present?
      agents = agents.where 'name like ? or company_name like ? or phone like ?', "%#{params[:table_search]}%", "%#{params[:table_search]}%", "%#{params[:table_search]}%"
    end
    agents
  end

  def city_name
    return ChinaCity.get(county, prepend_parent: true) if county.present?
    ChinaCity.get(city, prepend_parent: true)
  end

end
