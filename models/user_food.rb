require 'active_record'

class User_Food < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user
end
