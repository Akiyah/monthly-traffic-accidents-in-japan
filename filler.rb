class Filler
  def fill(data)
    puts "fill"

    puts "fill(1)"
    # "計"を追加
    data.each do |year, _|
      data[year].each do |month, _|
        data[year][month].each do |area, prefectures|
          prefectures["計"] ||= Measure.sum(prefectures)
        end
      end
    end

    puts "fill(2)"
    # 今月の月末と前月の月末から今月の月中を計算
    data.each do |year, _|
      data[year].each do |month, _|
        data[year][month].each do |area, _|
          data[year][month][area].each do |prefecture, m|
            if data[year][month - 1]
              m2 = data[year][month - 1][area][prefecture]
              Measure.diff345to123(m, m2)
            end
          end
        end
      end
    end

    puts "fill(3)"
    # 増減数から去年の値を計算
    data.dup.each do |year, _|
      data[year].dup.each do |month, _|
        data[year][month].dup.each do |area, _|
          data[year][month][area].dup.each do |prefecture, m|
            m1 = Measure.diff012345to_(m)

            if m1
              data[year - 1] ||= {}
              data[year - 1][month] ||= {}
              data[year - 1][month][area] ||= {}
              data[year - 1][month][area][prefecture] ||= m1
            end
          end
        end
      end
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    data.dup.each do |year, _|
      data[year].dup.each do |month, _|
        data[year][month].dup.each do |area, _|
          data[year][month][area].dup.each do |prefecture, m|
            if data[year][month + 2]
              m2 = data[year][month + 2][area][prefecture]
              data[year][month + 1] ||= {}
              data[year][month + 1][area] ||= {}
              data[year][month + 1][area][prefecture] ||= Measure.create_next_month_from_this_month_and_next_next_month(m, m2)
            end
          end
        end
      end
    end

    data
  end
end
