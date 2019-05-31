module DateHelper
  MONTH_DAYS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31].freeze

  class << self
    def convert_to_nums_array(every_calories_hash)
      every_calories_hash.each_key.map do |key|
        val = every_calories_hash[key]
        [key.to_i, val]
      end
    end

    def fill_calorie_of_monthly_as_zero(monthly_calories)
      (1..12).map do |i|
        month = '%02d' % i
        monthly_calories[month] ||= 0
      end
      monthly_calories
    end

    def fill_calorie_of_daily_as_zero(month, daily_calories)
      MONTH_DAYS[month - 1].times do |i|
        day = '%02d' % (i + 1)
        daily_calories[day] ||= 0
      end
      daily_calories
    end

    def find_day_of_month
      MONTH_DAYS[Time.current.month - 1]
    end
  end
end
