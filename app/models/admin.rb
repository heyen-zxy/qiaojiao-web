class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
  validates_presence_of :phone, :name
  validates_uniqueness_of :phone

  belongs_to :role

  def role? role_name
    self.role&.tag.to_s == role_name.to_s
  end
end
