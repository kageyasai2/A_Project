require 'active_record'

class UserFood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user
end
