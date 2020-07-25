require './lib/year_month_area_prefecture_data.rb'


Dir.mkdir('tsv') unless Dir.exist?('tsv')
Dir.mkdir('download') unless Dir.exist?('download')
Dir.mkdir('download/tsv') unless Dir.exist?('download/tsv')
Dir.mkdir('download/xls') unless Dir.exist?('download/xls')

data = YearMonthAreaPrefectureData.new('download/tsv', 'download/xls')

data.read
data.fill
data.write('tsv/monthly-traffic-accidents-in-japan.tsv')
