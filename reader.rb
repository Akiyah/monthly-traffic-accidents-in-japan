require 'roo'
require 'roo-xls'
require './params.rb'

class Reader
  def self.create(format)
    Module.const_get("Reader#{format}").new
    #"Reader#{format}".constantize.new
    #format == 'B' ? ReaderB.new : ReaderA.new
  end

  def read(filename, sheet0, sheet1)
    if filename.end_with?('xlsx')
      excel = Roo::Excelx.new(filename)
    else
      excel = Roo::Excel.new(filename)
    end

    data = {}
    area_prefecture_indexes.each do |area, prefectures|
      prefectures.each do |prefecture, i|
        data[area] ||= {}
        data[area][prefecture] = {
          v0: sheet0 ? excel.sheet(sheet0).cell(i, columns[:v0]).to_i : nil,
          v1: sheet0 ? excel.sheet(sheet0).cell(i, columns[:v1]).to_i : nil,
          v2: sheet0 ? excel.sheet(sheet0).cell(i, columns[:v2]).to_i : nil,
          v3: sheet1 ? excel.sheet(sheet1).cell(i, columns[:v0]).to_i : nil,
          v4: sheet1 ? excel.sheet(sheet1).cell(i, columns[:v1]).to_i : nil,
          v5: sheet1 ? excel.sheet(sheet1).cell(i, columns[:v2]).to_i : nil,
        }
      end
    end
    data
  end
end

class ReaderA < Reader
  def area_prefecture_indexes
    AREA_PREFECTURE_INDEXES_A
  end

  def columns
    {
      v0: 'C',
      v1: 'F',
      v2: 'J',
    }
  end
end

class ReaderB < Reader
  def area_prefecture_indexes
    AREA_PREFECTURE_INDEXES_B
  end

  def columns
    {
      v0: 'I',
      v1: 'J',
      v2: 'K',
    }
  end
end
