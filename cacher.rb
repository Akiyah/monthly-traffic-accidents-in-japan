require 'csv'
require './measure.rb'

class Cacher
  def get(year, month)
    filename = "download/tsv/#{year}_#{month}.tsv"
    return nil unless File.exist?(filename)

    data_ym = {}
    CSV.foreach("download/tsv/#{year}_#{month}.tsv", col_sep: "\t") do |row|
      year, month, area, prefecture, *v = row
      m = Measure.a_to_h(v)
      data_ym[area] ||= {}
      data_ym[area][prefecture] = m
    end

    data_ym
  end

  def set(year, month, data_ym)
    Dir.mkdir('download') unless Dir.exist?('download')
    Dir.mkdir('download/tsv') unless Dir.exist?('download/tsv')

    CSV.open("download/tsv/#{year}_#{month}.tsv",'w', col_sep: "\t") do |tsv|
      data_ym.each do |area, _|
        data_ym[area].each do |prefecture, v|
          tsv << [year, month, area, prefecture] + Measure.h_to_a(v)
        end
      end
    end
  end
end



