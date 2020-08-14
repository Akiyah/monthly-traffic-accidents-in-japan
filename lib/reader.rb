require './lib/params.rb'
require './lib/csv_wrapper.rb'

class Reader
  def self.create(format)
    Module.const_get("Reader#{format}").new
  end

  def read(filename)
    puts "read: #{filename}"
    csv_wrapper = CsvWrapper.new(filename)

    area_prefecture_indexes.each do |area, prefectures|
      prefectures.each do |prefecture, row|
        cm = ComparedMeasures.map_sheet_row(sheets, columns) do |sheet, column|
          csv_wrapper.read(sheet, row, column).to_i
        end
        yield(area, prefecture, cm)
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
      value: {
        accidents: 'C',
        fatalities: 'F',
        injuries: 'J'
      },
      change: {
        accidents: 'D',
        fatalities: 'G',
        injuries: 'K'
      }
    }
  end
end

class ReaderA1 < ReaderA
  def sheets
    { monthly: '表4-1', yearly: '表4-2' }
  end
end

class ReaderA2 < ReaderA
  def sheets
    { monthly: nil, yearly: '表6-2' }
  end
end

class ReaderA3 < ReaderA
  def sheets
    { monthly: '県別_表24', yearly: '県別_表25' }
  end
end

class ReaderA4 < ReaderA
  def sheets
    { monthly: '県別_表24', yearly: '県別_表24' }
  end
end

class ReaderB < Reader
  def area_prefecture_indexes
    AREA_PREFECTURE_INDEXES_B
  end

  def columns
    {
      value: {
        accidents: 'I',
        fatalities: 'J',
        injuries: 'K'
      },
      change: {
        accidents: nil,
        fatalities: nil,
        injuries: nil
      }
    }
  end
end

class ReaderB1 < ReaderB
  def sheets
    { monthly: nil, yearly: '県別人口（P41）' }
  end
end

class ReaderB2 < ReaderB
  def sheets
    { monthly: nil, yearly: '県別人口（P38）' }
  end
end

class ReaderB3 < ReaderB
  def sheets
    { monthly: nil, yearly: '県別人口（P40）' }
  end
end
