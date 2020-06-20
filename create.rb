require 'roo'
require 'roo-xls'
require 'csv'
require 'date'
require './params.rb'
require './reader.rb'
require './downloader.rb'

data = {}
downloader = Downloader.new
PARAMS.each do |param|
  year = param[:year]
  month = param[:month]
  sheet = param[:sheet]
  type = param[:type]

  filename = downloader.download(param)

  reader = (type == 'B' ? ReaderB.new : ReaderA.new)
  data[year] ||= {}
  data[year][month] = reader.read(filename, sheet)
end

CSV.open('tsv/monthly-traffic-accidents-in-japan.tsv','w', col_sep: "\t") do |tsv|
  tsv << %w(year month area prefecture 発生件数（速報値） 死者数（確定値） 負傷者数（速報値）)
  data.each do |year, v|
    data[year].each do |month, v|
      data[year][month].each do |area, v|
        data[year][month][area].each do |prefecture, v|
          v0, v1, v2 = data[year][month][area][prefecture]
          if month == 1
            tsv << [year, month, area, prefecture, v0, v1, v2]
          elsif data[year][month - 1]
            w0, w1, w2 = data[year][month - 1][area][prefecture]
            tsv << [year, month, area, prefecture, v0 - w0, v1 - w1, v2 - w2]
          end
        end
      end
    end
  end
end
