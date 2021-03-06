require 'roo'
require 'roo-xls'

class CsvWrapper
  def initialize(filename)
    if filename.end_with?('xlsx')
      @excel = Roo::Excelx.new(filename)
    else
      @excel = Roo::Excel.new(filename)
    end

    @csv_data = {}
  end

  def read(sheet, row, column)
    @csv_data[sheet] ||= CSV.parse(@excel.sheet(sheet).to_csv)

    column_index = ('A'..'Z').to_a.index(column)
    row_index = row - 1
    @csv_data[sheet][row_index][column_index]
  end
end
