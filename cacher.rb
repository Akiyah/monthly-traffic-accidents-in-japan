require 'csv'
require './compared_measures.rb'

class Cacher
  def filename(year, month)
    "download/tsv/#{year}_#{month}.tsv"
  end

  def exists?(year, month)
    File.exist?(filename(year, month))
  end

  def read(year, month)
    CSV.foreach(filename(year, month), col_sep: "\t") do |row|
      year, month, area, prefecture, *a = row
      cm = ComparedMeasures.new(*a)
      yield(area, prefecture, cm)
    end
  end

  def write(year, month, data)
    Dir.mkdir('download') unless Dir.exist?('download')
    Dir.mkdir('download/tsv') unless Dir.exist?('download/tsv')

    CSV.open(filename(year, month), 'w', col_sep: "\t") do |tsv|
      data.each_ym(year, month) do |area, prefecture, cm|
        tsv << [year, month, area, prefecture] + cm.to_a
      end
    end
  end
end



