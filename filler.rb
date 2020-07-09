class Filler
  def fill(data)
    puts "fill(1)"
    # "計"を追加
    data.each_year_month_area do |year, month, area, prefectures|
      unless prefectures["計"]
        m_sum = Measure.sum(prefectures)
        data.set(year, month, area, "計", m_sum.to_h)
      end
    end

    puts "fill(2)"
    # 今月の月末と前月の月末から今月の月中を計算
    data.each do |year, month, area, prefecture, h|
      next if h[:v0] && h[:v1] && h[:v2] && h[:v0_] && h[:v1_] && h[:v2_]

      if data.get(year, month - 1, area, prefecture)
        m = Measure.create_from_h(h)
        h1 = data.get(year, month - 1, area, prefecture)
        m1 = Measure.create_from_h(h1)

        m2 = m.diff345to123(m1)
        data.set(year, month, area, prefecture, m2.to_h)
      end
    end

    puts "fill(3)"
    # 増減数から去年の値を計算
    data.each do |year, month, area, prefecture, h|
      m = Measure.create_from_h(h)
      m1 = m.diff012345to_
      if m1 && !data.get(year - 1, month, area, prefecture)
        data.set(year - 1, month, area, prefecture, m1.to_h)
      end
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    data.each do |year, month, area, prefecture, h|
      if data.exists?(year, month + 2)
        h2 = data.get(year, month + 2, area, prefecture)
        if h2
          unless data.get(year, month + 1, area, prefecture)
            m = Measure.create_from_h(h)
            m2 = Measure.create_from_h(h2)
            m1 = m.create_next_month_from_next_next_month(m2)
            data.set(year, month + 1, area, prefecture, m1.to_h)
          end
        end
      end
    end
  end
end
