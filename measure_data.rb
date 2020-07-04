class MeasureData
  def initialize
    @data = {}
  end

  def get(year, month, area, prefecture)
    @data[year][month][area][prefecture]
  end

  def exists?(year, month)
    @data[year][month]
  end

  def set(year, month, area, prefecture, m)
    @data[year] ||= {}
    @data[year][month] ||= {}
    @data[year][month][area] ||= {}
    @data[year][month][area][prefecture] ||= m
  end

  def set_ym(year, month, d)
    @data[year] ||= {}
    @data[year][month] ||= d
  end

  def each
    @data.dup.each do |year, _|
      @data[year].dup.each do |month, _|
        @data[year][month].dup.each do |area, _|
          @data[year][month][area].dup.each do |prefecture, m|
            yield(year, month, area, prefecture, m)
          end
        end
      end
    end
  end

  def each_year_month_area
    @data.dup.each do |year, _|
      @data[year].dup.each do |month, _|
        @data[year][month].dup.each do |area, prefectures|
          yield(year, month, area, prefectures)
        end
      end
    end
  end
end