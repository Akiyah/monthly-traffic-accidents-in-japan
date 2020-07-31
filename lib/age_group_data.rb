require 'csv'
require './lib/reader.rb'
require './lib/reader2.rb'
require './lib/downloader.rb'
require './lib/cacher.rb'
require './lib/params.rb'
require './lib/compared_measures.rb'

class AgeGroupData
  def initialize(path_tsv, path_xls)
    @path_tsv = path_tsv
    @path_xls = path_xls
    @data = {}
  end

  def get(year, month, age_group, road_user_type)
    @data.dig(year, month, age_group, road_user_type)
  end

  def set(year, month, age_group, road_user_type, value)
    @data[year] ||= {}
    @data[year][month] ||= {}
    @data[year][month][age_group] ||= {}
    @data[year][month][age_group][road_user_type] = value
  end

  def each
    @data.dup.each do |year, _|
      @data[year].dup.each do |month, _|
        @data[year][month].dup.each do |age_group, _|
          @data[year][month][age_group].dup.each do |road_user_type, value|
            yield(year, month, age_group, road_user_type, value)
          end
        end
      end
    end
  end

  def read
    downloader = Downloader.new(@path_xls)
    PARAMS[0...12].each do |param|
      last_year = param[:year]
      month = param[:month]
      url = param[:url]
    
      filename = downloader.download(last_year, month, url)
      reader = Reader2.new(last_year, month)
      reader.read(filename) do |year, month, age_group, road_user_type, value|
        set(year, month, age_group, road_user_type, value)
      end
    end
  end

  def diff
    d = AgeGroupData.new(@path_tsv, @path_xls)
    each do |year, month, age_group, road_user_type, value|
      if 1 < month
        value_last_month = get(year, month - 1, age_group, road_user_type)
        v = value_last_month ? value - value_last_month : nil
      else
        v = value
      end
      d.set(year, month, age_group, road_user_type, v)
    end
    d
  end

  def write(path)
    puts "write tsv file"
    CSV.open(path,'w', col_sep: "\t") do |tsv|
      tsv << %w(年 月 年齢層 状態 数)
      each do |year, month, age_group, road_user_type, value|
        tsv << [year, month, age_group, road_user_type, value] if value
      end
    end
  end
end
