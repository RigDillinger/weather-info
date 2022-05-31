class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable, :registerable

  enum role: { viewer: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
