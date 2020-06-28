require 'roo'
require 'roo-xls'
require './params.rb'

class Reader
  def self.create(format)
    Module.const_get("Reader#{format}").new
  end

  def read_cell(excel, sheet, i, column)
    return nil unless sheet
    return nil unless column

    excel.sheet(sheet).cell(i, column).to_i
  end

  def read(filename)
    puts "read: #{filename}"
    if filename.end_with?('xlsx')
      excel = Roo::Excelx.new(filename)
    else
      excel = Roo::Excel.new(filename)
    end

    sheet0, sheet1 = sheets

    data = {}
    area_prefecture_indexes.each do |area, prefectures|
      prefectures.each do |prefecture, i|
        data[area] ||= {}
        data[area][prefecture] = {
          v0: read_cell(excel, sheet0, i, columns[:v0]),
          v1: read_cell(excel, sheet0, i, columns[:v1]),
          v2: read_cell(excel, sheet0, i, columns[:v2]),
          v3: read_cell(excel, sheet1, i, columns[:v0]),
          v4: read_cell(excel, sheet1, i, columns[:v1]),
          v5: read_cell(excel, sheet1, i, columns[:v2]),
          v0_: read_cell(excel, sheet0, i, columns[:v0_]),
          v1_: read_cell(excel, sheet0, i, columns[:v1_]),
          v2_: read_cell(excel, sheet0, i, columns[:v2_]),
          v3_: read_cell(excel, sheet1, i, columns[:v0_]),
          v4_: read_cell(excel, sheet1, i, columns[:v1_]),
          v5_: read_cell(excel, sheet1, i, columns[:v2_]),
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
