require 'csv'
require './lib/reader.rb'
require './lib/downloader.rb'
require './lib/params.rb'
require './lib/compared_measures.rb'

class YearMonthAreaPrefectureData
  def initialize(path_xls)
    @path_xls = path_xls
    @data = {}
  end

  def get(year, month, area, prefecture)
    @data.dig(year, month, area, prefecture)
  end

  def set(year, month, area, prefecture, cm)
    return unless cm
    @data[year] ||= {}
    @data[year][month] ||= {}
    @data[year][month][area] ||= {}
    @data[year][month][area][prefecture] = cm
  end

  def set_if_nil(year, month, area, prefecture, cm)
    unless get(year, month, area, prefecture)
      set(year, month, area, prefecture, cm)
    end
  end

  def each
    @data.dup.each do |year, _|
      @data[year].dup.each do |month, _|
        each_ym(year, month) do |area, prefecture, cm|
          yield(year, month, area, prefecture, cm)
        end
      end
    end
  end

  def each_ym(year, month)
    @data[year][month].dup.each do |area, _|
      @data[year][month][area].dup.each do |prefecture, cm|
        yield(area, prefecture, cm)
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

  def read
    downloader = Downloader.new(@path_xls)
    PARAMS.each do |param|
      year = param[:year]
      month = param[:month]
      url = param[:url]
      format = param[:format]

      filename = downloader.download(year, month, url)
      reader = Reader.create(format)
      reader.read(filename) do |area, prefecture, cm|
        set(year, month, area, prefecture, cm)
      end
    end
  end

  def fill
    puts "fill(1)"
    # "計"を追加
    each_year_month_area do |year, month, area, prefectures|
      cm_sum = ComparedMeasures.sum(prefectures)
      set_if_nil(year, month, area, "計", cm_sum)
    end

    puts "fill(2)"
    # 今月の月末と前月の月末から今月の月中を計算
    each do |year, month, area, prefecture, cm|
      cm_last_month = get(year, month - 1, area, prefecture)
      if cm_last_month
        cm_new = cm.fill_monthly_measures(cm_last_month)
        set(year, month, area, prefecture, cm_new)
      end
    end

    puts "fill(3)"
    # 増減数から去年の値を計算
    each do |year, month, area, prefecture, cm|
      set_if_nil(year - 1, month, area, prefecture, cm.last_year)
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    each do |year, month, area, prefecture, cm|
      cm_next_next_month = get(year, month + 2, area, prefecture)
      if cm_next_next_month
        cm_next_month = cm.next_month(cm_next_next_month)
        set_if_nil(year, month + 1, area, prefecture, cm_next_month)
      end
    end
  end

  def write(path)
    puts "write tsv file"
    CSV.open(path,'w', col_sep: "\t") do |tsv|
      tsv << %w(年 月 管区 都道府県 発生件数（速報値） 死者数（確定値） 負傷者数（速報値）)
      each do |year, month, area, prefecture, cm|
        tsv << [year, month, area, prefecture] + cm.monthly_value.to_a
      end
    end
  end
end
