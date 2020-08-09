require './lib/year_month_area_prefecture_data.rb'
require './lib/age_group_data.rb'


Dir.mkdir('tsv') unless Dir.exist?('tsv')
Dir.mkdir('download') unless Dir.exist?('download')
Dir.mkdir('download/xls') unless Dir.exist?('download/xls')

data = YearMonthAreaPrefectureData.new('download/xls')

data.read
data.fill
data.write('tsv/monthly-traffic-accidents-in-japan.tsv')

data2 = AgeGroupData.new('download/xls')
data2.read
data3 = data2.diff
data3.write('tsv/age_group.tsv')
