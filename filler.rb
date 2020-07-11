class Filler
  def fill(data)
    puts "fill(1)"
    # "計"を追加
    data.each_year_month_area do |year, month, area, prefectures|
      #unless prefectures["計"]
        cm_sum = ComparedMeasures.sum(prefectures)
        data.set_if_nil(year, month, area, "計", cm_sum)
      #end
    end

    puts "fill(2)"
    # 今月の月末と前月の月末から今月の月中を計算
    data.each do |year, month, area, prefecture, cm|
      next if !cm.measures.empty? && !cm.measures_change.empty?

      cm_last_month = data.get(year, month - 1, area, prefecture)
      if cm_last_month
        cm_new = cm.fill_measures(cm_last_month)
        data.set(year, month, area, prefecture, cm_new)
      end
    end

    puts "fill(3)"
    # 増減数から去年の値を計算
    data.each do |year, month, area, prefecture, cm|
      data.set_if_nil(year - 1, month, area, prefecture, cm.last_year)
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    data.each do |year, month, area, prefecture, cm|
      cm_next_next_month = data.get(year, month + 2, area, prefecture)
      if cm_next_next_month
        cm_next_month = cm.next_month(cm_next_next_month)
        data.set_if_nil(year, month + 1, area, prefecture, cm_next_month)
      end
    end
  end
end
