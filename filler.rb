class Filler
  def fill(data)
    puts "fill(1)"
    # "計"を追加
    data.each_year_month_area do |year, month, area, prefectures|
      unless prefectures["計"]
        data.set(year, month, area, "計", Measure.sum(prefectures))
      end
    end

    puts "fill(2)"
    # 今月の月末と前月の月末から今月の月中を計算
    data.each do |year, month, area, prefecture, h|
      next if h[:v0] && h[:v1] && h[:v2] && h[:v0_] && h[:v1_] && h[:v2_]

      if data.exists?(year, month - 1)
        h1 = data.get(year, month - 1, area, prefecture)
        h2 = Measure.diff345to123(h, h1)
        data.set(year, month, area, prefecture, h2)
      end
    end

    puts "fill(3)"
    # 増減数から去年の値を計算
    data.each do |year, month, area, prefecture, h|
      h1 = Measure.diff012345to_(h)
      if h1 && !data.get(year - 1, month, area, prefecture)
        data.set(year - 1, month, area, prefecture, h1)
      end
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    data.each do |year, month, area, prefecture, h|
      if data.exists?(year, month + 2)
        h2 = data.get(year, month + 2, area, prefecture)
        if h2
          unless data.get(year, month + 1, area, prefecture)
            h1 = Measure.create_next_month_from_this_month_and_next_next_month(h, h2)
            data.set(year, month + 1, area, prefecture, h1)
          end
        end
      end
    end
  end
end
