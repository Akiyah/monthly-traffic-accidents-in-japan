require 'roo'
require 'csv'
require 'date'
require './params.rb'

data = {}
CSV.open('tsv/monthly-traffic-accidents-in-japan.tsv','w', col_sep: "\t") do |tsv|
  tsv << %w(year month area prefecture 発生件数（速報値） 死者数（確定値） 負傷者数（速報値）)

  PARAMS.each do |param|
    year = param[:year]
    month = param[:month]
    sheet = param[:sheet]
    sheet_before_month = param[:sheet_before_month]

    filename = "xlsx/#{year}_#{month}.xlsx"
    xlsx = Roo::Excelx.new(filename)

    if sheet_before_month
      filename_before_month = "xlsx/#{year}_#{month - 1}.xlsx"
      xlsx_before_month = Roo::Excelx.new(filename_before_month)
    end

    AREA_PREFECTURE.each_with_index do |area_prefecture, i|
      next unless area_prefecture
      area, prefecture = area_prefecture

      if !sheet_before_month
        v0 = xlsx.sheet(sheet).cell(i + 1, 'C').to_i
        v1 = xlsx.sheet(sheet).cell(i + 1, 'F').to_i
        v2 = xlsx.sheet(sheet).cell(i + 1, 'J').to_i
      else
        v0 = xlsx.sheet(sheet).cell(i + 1, 'C').to_i - xlsx_before_month.sheet(sheet_before_month).cell(i + 1, 'C').to_i
        v1 = xlsx.sheet(sheet).cell(i + 1, 'F').to_i - xlsx_before_month.sheet(sheet_before_month).cell(i + 1, 'F').to_i
        v2 = xlsx.sheet(sheet).cell(i + 1, 'J').to_i - xlsx_before_month.sheet(sheet_before_month).cell(i + 1, 'J').to_i
      end
      tsv << [year, month, area, prefecture, v0, v1, v2]
    end
  end
end