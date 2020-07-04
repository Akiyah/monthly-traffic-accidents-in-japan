class Filler
  def fill(data)
    puts "fill"

    puts "fill(1)"
    # "計"を追加
    data.each_year_month_area do |year, month, area, prefectures|
      data.set(year, month, area, "計", Measure.sum(prefectures))
    end

    puts "fill(2)"
    # 今月の月末と前月の月末から今月の月中を計算
    data.each do |year, month, area, prefecture, m|
      if data.exists?(year, month - 1)
        m2 = data.get(year, month - 1, area, prefecture)
        Measure.diff345to123(m, m2)
      end
    end

    puts "fill(3)"
    # 増減数から去年の値を計算
    data.each do |year, month, area, prefecture, m|
      m1 = Measure.diff012345to_(m)

      if m1
        data.set(year - 1, month, area, prefecture, m1)
      end
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    data.each do |year, month, area, prefecture, m|
      if data.exists?(year, month + 2)
        m2 = data.get(year, month + 2, area, prefecture)
        if m2
          m1 = Measure.create_next_month_from_this_month_and_next_next_month(m, m2)
          data.set(year, month + 1, area, prefecture, m1)
        end
      end
    end
  end
end
