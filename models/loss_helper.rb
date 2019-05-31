module LossHelper
  AVERAGE_INTAKE_CALORIE = 2000

  class << self
    def calc_kill_retio(discarded_calorie:, day_or_month: :day)
      case day_or_month
      when :day then
        discarded_calorie / AVERAGE_INTAKE_CALORIE.to_f
      when :month then
        discarded_calorie / (AVERAGE_INTAKE_CALORIE * DateHelper.find_day_of_month).to_f
      else
        raise AugumentError, 'day_or_month引数には:dayか:monthのどちらかを指定してください'
      end
    end
  end
end
