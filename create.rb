require 'roo'
require 'roo-xls'
require 'csv'
require 'date'
require './params.rb'
require './reader.rb'
require './downloader.rb'
require './filler.rb'

data = {}
downloader = Downloader.new
PARAMS.each do |param|
  year = param[:year]
  month = param[:month]
  url = param[:url]
  ext = param[:ext]
  sheets = param[:sheets]
  type = param[:type]

  filename = downloader.download(year, month, ext, url)

  reader = (type == 'B' ? ReaderB.new : ReaderA.new)
  data[year] ||= {}
  data[year][month] = reader.read(filename, sheets)
end

filler = Filler.new
data = filler.fill(data)

CSV.open('tsv/monthly-traffic-accidents-in-japan.tsv','w', col_sep: "\t") do |tsv|
  tsv << %w(年 月 管区 都道府県 発生件数（速報値） 死者数（確定値） 負傷者数（速報値） 発生件数（速報値）月末 死者数（確定値）月末 負傷者数（速報値）月末)
  data.each do |year, _|
    data[year].each do |month, _|
      data[year][month].each do |area, _|
        data[year][month][area].each do |prefecture, v|
          tsv << [year, month, area, prefecture, v[:v0], v[:v1], v[:v2], v[:v3], v[:v4], v[:v5]]
        end
      end
    end
  end
end
