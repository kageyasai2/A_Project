require 'active_record'

class Userfood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  validates :gram, presence: true
  belongs_to :user
end