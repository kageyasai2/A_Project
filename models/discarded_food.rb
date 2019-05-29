require 'active_record'

class DiscardedFood < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 50 }
  belongs_to :user

  scope :where_my, -> (user_id) { where(user_id: user_id) }
  scope :where_current_year, -> { where(created_at: Time.current.all_year) }
  scope :where_current_month, -> { where(created_at: Time.current.all_month) }
  scope :group_by_month, -> { group('STRFTIME("%m", DATE(created_at))') }
  scope :group_by_date, -> { group('STRFTIME("%d", DATE(created_at))') }
  scope :sum_calorie, -> { sum(:calorie) }
end
