require './year_month_area_prefecture_data.rb'

data = YearMonthAreaPrefectureData.new

data.read
data.fill
data.write
