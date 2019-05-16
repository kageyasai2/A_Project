require 'active_record'

class Userfood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user
end
