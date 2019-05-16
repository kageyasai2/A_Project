require 'active_record'

class Userfood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  validates :limit_date , presence: true
  validates :gram, presence: true
end