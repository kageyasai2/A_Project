module ContributionHelper
  AVERAGE_DISCARDED_CALORIE = 42

  class << self
    def calc_contribute_num(discarded_calorie:, day_or_month: :day)
      case day_or_month
      when :month then
        (AVERAGE_DISCARDED_CALORIE * DateHelper.find_day_of_month) - discarded_calorie
      when :day then
        AVERAGE_DISCARDED_CALORIE - discarded_calorie
      else
        raise AugumentError, 'day_or_month引数には:dayか:monthのどちらかを指定してください'
      end
    end
  end
end
