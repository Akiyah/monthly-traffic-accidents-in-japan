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
        if data[year][month - 1]
          data[year][month].each do |area, _|
            data[year][month][area].each do |prefecture, m|
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
        if !(data[year - 1] && data[year - 1][month])
          data[year][month].dup.each do |area, _|
            data[year][month][area].dup.each do |prefecture, v|
              m2 = Measure.diff012345to_(v)

              if m2
                data[year - 1] ||= {}
                data[year - 1][month] ||= {}
                data[year - 1][month][area] ||= {}
                data[year - 1][month][area][prefecture] = m2
              end
            end
          end
        end
      end
    end

    puts "fill(4)"
    # 今月と再来月から来月の値を計算
    data.dup.each do |year, _|
      data[year].dup.each do |month, _|
        if !data[year][month + 1] && data[year][month + 2]
          data[year][month + 1] ||= {}
          data[year][month].dup.each do |area, _|
            data[year][month + 1][area] ||= {}
            data[year][month][area].dup.each do |prefecture, v|
              w = data[year][month + 2][area][prefecture]
              v3 = w[:v3] - w[:v0]
              v4 = w[:v4] - w[:v1]
              v5 = w[:v5] - w[:v2]
              v0 = v3 - v[:v3]
              v1 = v4 - v[:v4]
              v2 = v5 - v[:v5]
              data[year][month + 1][area][prefecture] = {
                v0: v0,
                v1: v1,
                v2: v2,
                v3: v3,
                v4: v4,
                v5: v5,
                v0_: nil,
                v1_: nil,
                v2_: nil,
                v3_: nil,
                v4_: nil,
                v5_: nil,
              }
            end
          end
        end
      end
    end

    data
  end
end
