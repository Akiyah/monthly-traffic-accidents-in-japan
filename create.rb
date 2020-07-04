require 'roo'
require 'roo-xls'
require 'csv'
require 'date'
require './params.rb'
require './reader.rb'
require './downloader.rb'
require './cacher.rb'
require './filler.rb'
require './measure.rb'
require './measure_data.rb'

data = MeasureData.new
downloader = Downloader.new
cacher = Cacher.new
PARAMS.each do |param|
  year = param[:year]
  month = param[:month]
  url = param[:url]
  format = param[:format]

  data_ym = cacher.get(year, month)
  unless data_ym
    filename = downloader.download(year, month, url)
    reader = Reader.create(format)
    data_ym = reader.read(filename)
    cacher.set(year, month, data_ym)
  end

  data.set_ym(year, month, data_ym)
end

Filler.new.fill(data)

puts "write tsv file"
CSV.open('tsv/monthly-traffic-accidents-in-japan.tsv','w', col_sep: "\t") do |tsv|
  tsv << %w(年 月 管区 都道府県 発生件数（速報値） 死者数（確定値） 負傷者数（速報値）)
  data.each do |year, month, area, prefecture, m|
    tsv << [year, month, area, prefecture] + Measure.h_to_a3(m)
  end
end
