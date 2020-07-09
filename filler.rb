class Filler
  def fill(data)
    puts "fill(1)"
    # "計"を追加
    data.each_year_month_area do |year, month, area, prefectures|
      unless prefectures["計"]
        m_sum = Measure.sum(prefectures)
        data.set(year, month, area, "計", m_sum)
      end
    end

    puts "fill(2)"
    # 今月の月末と前月の月末から今月の月中を計算
    data.each do |year, month, area, prefecture, m|
      next if m.v0 && m.v1 && m.v2 && m.v0_ && m.v1_ && m.v2_

      if data.get(year, month - 1, area, prefecture)
        m1 = data.get(year, month - 1, area, prefecture)
        m2 = m.diff345to123(m1)
        data.set(year, month, area, prefecture, m2)
      end
    end

    puts "fill(3)"
    # 増減数から去年の値を計算
    data.each do |year, month, area, prefecture, m|
      m1 = m.diff012345to_
      if m1 && !data.get(year - 1, month, area, prefecture)
        data.set(year - 1, month, area, prefecture, m1)
      end
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    data.each do |year, month, area, prefecture, m|
      m2 = data.get(year, month + 2, area, prefecture)
      if m2
        unless data.get(year, month + 1, area, prefecture)
          m1 = m.create_next_month_from_next_next_month(m2)
          data.set(year, month + 1, area, prefecture, m1)
        end
      end
    end
  end
end
