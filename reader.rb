require 'roo'
require 'roo-xls'
require './params.rb'

class Reader
  def self.create(format)
    Module.const_get("Reader#{format}").new
  end

  def read(filename)
    puts "read: #{filename}"
    if filename.end_with?('xlsx')
      excel = Roo::Excelx.new(filename)
    else
      excel = Roo::Excel.new(filename)
    end

    sheet0, sheet1 = sheets

    area_prefecture_indexes.each do |area, prefectures|
      prefectures.each do |prefecture, row|
        m = ComparedMeasures.map_sheet_row(sheet0, sheet1, columns) do |sheet, column|
          excel.sheet(sheet).cell(row, column).to_i
        end
        yield(area, prefecture, m)
      end
    end
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
      v0_: 'D',
      v1_: 'G',
      v2_: 'K',
    }
  end
end

class ReaderA1 < ReaderA
  def sheets
    ['表4-1', '表4-2']
  end
end

class ReaderA2 < ReaderA
  def sheets
    [nil, '表6-2']
  end
end

class ReaderA3 < ReaderA
  def sheets
    ['県別_表24', '県別_表25']
  end
end

class ReaderA4 < ReaderA
  def sheets
    ['県別_表24', '県別_表24']
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
      v0_: nil,
      v1_: nil,
      v2_: nil,
    }
  end
end

class ReaderB1 < ReaderB
  def sheets
    [nil, '県別人口（P41）']
  end
end

class ReaderB2 < ReaderB
  def sheets
    [nil, '県別人口（P38）']
  end
end

class ReaderB3 < ReaderB
  def sheets
    [nil, '県別人口（P40）']
  end
end
