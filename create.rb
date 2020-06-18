require 'roo'
require 'csv'
require 'date'
require './params.rb'

CSV.open('tsv/monthly-traffic-accidents-in-japan.tsv','w', col_sep: "\t") do |tsv|
  tsv << %w(year month area prefecture 発生件数（速報値） 死者数（確定値） 負傷者数（速報値）)

  PARAMS.each do |param|
    year = param[:year]
    month = param[:month]
    sheet = param[:sheet]
    filename = "xlsx/#{year}_#{month}.xlsx"

    xlsx = Roo::Excelx.new(filename)
    AREA_PREFECTURE.each_with_index do |area_prefecture, i|
      next unless area_prefecture
      area, prefecture = area_prefecture

      v0 = xlsx.sheet(sheet).cell(i + 1, 'C')
      v1 = xlsx.sheet(sheet).cell(i + 1, 'F')
      v2 = xlsx.sheet(sheet).cell(i + 1, 'J')
      tsv << [year, month, area, prefecture, v0, v1, v2]
    end
  end
end