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
            data[year][month][area].each do |prefecture, v|
              w = data[year][month - 1][area][prefecture]
              v[:v0] ||= v[:v3] - w[:v3]
              v[:v1] ||= v[:v4] - w[:v4]
              v[:v2] ||= v[:v5] - w[:v5]
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
              if %i(v0_ v1_ v2_ v3_ v4_ v5_).all? { |k| v[k] }
                data[year - 1] ||= {}
                data[year - 1][month] ||= {}
                data[year - 1][month][area] ||= {}
                data[year - 1][month][area][prefecture] = {
                  v0: v[:v0] - v[:v0_],
                  v1: v[:v1] - v[:v1_],
                  v2: v[:v2] - v[:v2_],
                  v3: v[:v3] - v[:v3_],
                  v4: v[:v4] - v[:v4_],
                  v5: v[:v5] - v[:v5_],
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
