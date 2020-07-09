require 'csv'
require './measure.rb'

class Cacher
  def filename(year, month)
    "download/tsv/#{year}_#{month}.tsv"
  end

  def exists?(year, month)
    File.exist?(filename(year, month))
  end

  def read(year, month)
    CSV.foreach(filename(year, month), col_sep: "\t") do |row|
      year, month, area, prefecture, *v = row
      h = Measure.a_to_h(v)
      yield(area, prefecture, h)
    end
  end

  def write(year, month, data)
    Dir.mkdir('download') unless Dir.exist?('download')
    Dir.mkdir('download/tsv') unless Dir.exist?('download/tsv')

    CSV.open(filename(year, month), 'w', col_sep: "\t") do |tsv|
      data.each_ym(year, month) do |area, prefecture, h|
        tsv << [year, month, area, prefecture] + Measure.h_to_a(h)
      end
    end
  end
end



