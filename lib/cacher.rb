require 'csv'
require './lib/compared_measures.rb'

class Cacher
  def initialize(path)
    @path = path
  end

  def filename(year, month)
    "#{@path}/#{year}_#{month}.tsv"
  end

  def exists?(year, month)
    File.exist?(filename(year, month))
  end

  def read(year, month)
    CSV.foreach(filename(year, month), col_sep: "\t") do |row|
      year, month, area, prefecture, *a = row
      cm = ComparedMeasures.create_from_a(a)
      yield(area, prefecture, cm)
    end
  end

  def write(year, month, data)
    CSV.open(filename(year, month), 'w', col_sep: "\t") do |tsv|
      data.each_ym(year, month) do |area, prefecture, cm|
        tsv << [year, month, area, prefecture] + cm.to_a
      end
    end
  end
end



