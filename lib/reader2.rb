require './lib/params.rb'
require './lib/csv_wrapper.rb'

class Reader2
  def self.create(format, last_year, month)
    Module.const_get("Reader2#{format}").new(last_year, month)
  end

  def initialize(last_year, month)
    @last_year = last_year
    @month = month
  end

  def read(filename)
    puts "read: #{filename}, #{@last_year}, #{@month}"
    csv_wrapper = CsvWrapper.new(filename)

    year_column.each do |year, column|
      age_group_sheet_rows.each do |age_group, sheet, rows|
        road_user_type_index.each do |road_user_type, index|
          value = rows.sum do |row|
            csv_wrapper.read(sheet, row + index, column).to_i
          end
          yield(year, @month, age_group, road_user_type, value)
        end
      end
    end
  end

  def year_column
    [
      [@last_year -  0, 'M'],
      [@last_year -  1, 'L'],
      [@last_year -  2, 'K'],
      [@last_year -  3, 'J'],
      [@last_year -  4, 'I'],
      [@last_year -  5, 'H'],
      [@last_year -  6, 'G'],
      [@last_year -  7, 'F'],
      [@last_year -  8, 'E'],
      [@last_year -  9, 'D'],
      [@last_year - 10, 'C']
    ]
  end

  def road_user_type_index()
    [
      ['自動車乗車中', 0],
      ['自動二輪車乗車中', 1],
      ['原付乗車中', 2],
      ['自転車乗用中', 3],
      ['歩行中', 4],
      ['その他', 5]
    ]
  end
end

class Reader2A1 < Reader2
  def age_group_sheet_rows
    [
      ['9歳以下', '表2-5', [7]],
      ['10-19歳', '表2-5', [14]],
      ['20-29歳', '表2-5', [21]],
      ['30-39歳', '表2-5', [28]],
      ['40-49歳', '表2-5', [35]],
      ['50-59歳', '表2-5', [42]],
      ['60-64歳', '表2-5', [49]],
      ['65-69歳', '表2-6', [7]],
      ['70-74歳', '表2-6', [14]],
      ['75-79歳', '表2-6', [21]],
      ['80-84歳', '表2-6', [28]],
      ['85歳以上', '表2-6', [35]]
    ]
  end
end

class Reader2A2 < Reader2
  def age_group_sheet_rows
    [
      ['9歳以下', '表2-3-2', [7, 14]],
      ['10-19歳', '表2-3-2', [21, 28]],
      ['20-29歳', '表2-3-2', [35, 42]],
      ['30-39歳', '表2-3-2', [49, 56]],
      ['40-49歳', '表2-3-2', [63, 70]],
      ['50-59歳', '表2-3-2', [77, 84]],
      ['60-64歳', '表2-3-2', [91]],
      ['65-69歳', '表2-3-2', [98]],
      ['70-74歳', '表2-3-2', [105]],
      ['75-79歳', '表2-3-2', [112]],
      ['80-84歳', '表2-3-2', [119]],
      ['85歳以上', '表2-3-2', [126]]
    ]
  end
end

class Reader2A1b < Reader2A1
  def age_group_sheet_rows
    super.map do |age_group, sheet, rows|
      [age_group, sheet, rows.map{ |row| row - 1 }]
    end
  end
end
