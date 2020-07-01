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

data = {}
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

  data[year] ||= {}
  data[year][month] = data_ym
end

filler = Filler.new
data = filler.fill(data)

puts "write tsv file"
CSV.open('tsv/monthly-traffic-accidents-in-japan.tsv','w', col_sep: "\t") do |tsv|
  tsv << %w(年 月 管区 都道府県 発生件数（速報値） 死者数（確定値） 負傷者数（速報値）)
  data.each do |year, _|
    data[year].each do |month, _|
      data[year][month].each do |area, _|
        data[year][month][area].each do |prefecture, v|
          tsv << [year, month, area, prefecture] + Measure.h_to_a3(v)
        end
      end
    end
  end
end
