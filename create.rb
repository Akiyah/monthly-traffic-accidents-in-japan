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

  if cacher.exists?(year, month)
    cacher.read(year, month) do |area, prefecture, h|
      data.set(year, month, area, prefecture, h)
    end
  else
    filename = downloader.download(year, month, url)
    reader = Reader.create(format)
    reader.read(filename) do |area, prefecture, h|
      data.set(year, month, area, prefecture, h)
    end
    cacher.write(year, month, data)
  end
end

Filler.new.fill(data)

puts "write tsv file"
CSV.open('tsv/monthly-traffic-accidents-in-japan.tsv','w', col_sep: "\t") do |tsv|
  tsv << %w(年 月 管区 都道府県 発生件数（速報値） 死者数（確定値） 負傷者数（速報値）)
  data.each do |year, month, area, prefecture, h|
    tsv << [year, month, area, prefecture] + Measure.create_from_h(h).to_a[0..2]
  end
end
