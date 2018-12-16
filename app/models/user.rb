class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
          :rememberable, :trackable, :validatable, :recoverable
  include DeviseTokenAuth::Concerns::User

  has_many :projects, dependent: :destroy
end
