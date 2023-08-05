require 'roo'
require 'roo-xls'

class CsvWrapper
  def initialize(filenames)
    @excels = Array(filenames).map do |filename|
      if filename.end_with?('xlsx')
        Roo::Excelx.new(filename)
      else
        Roo::Excel.new(filename)
      end
    end

    @csv_data = {}
  end

  def sheet(sheet_name)
    @excels.each do |excel|
      begin
        return excel.sheet(sheet_name)
      rescue
      end
    end
    nil
  end

  def read(sheet_name, row, column)
    @csv_data[sheet_name] ||= CSV.parse(sheet(sheet_name).to_csv)

    column_index = ('A'..'Z').to_a.index(column)
    row_index = row - 1
    @csv_data[sheet_name][row_index][column_index]
  end
end
