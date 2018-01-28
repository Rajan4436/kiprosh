class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :notes


  ROLES = {
  	0 => :guest, # can see shared post
  	1 => :moderator, # can update user
  	2 => :owner, # can CRUD notes ie. current user
  	3 => :admin # Full access
  }

end
