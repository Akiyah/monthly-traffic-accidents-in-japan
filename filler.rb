class Filler
  def fill(data)
    data.each do |year, _|
      data[year].each do |month, _|
        data[year][month].each do |area, d|
          unless d["計"]
            h = %i(v0 v1 v2 v3 v4 v5).map do |v|
              if d.all? { |prefecture, x| x[v] }
                [v, d.sum { |prefecture, x| x[v] }]
              else
                [v, nil]
              end
            end.to_h
            d["計"] = h
          end
        end
      end
    end

    data.each do |year, _|
      data[year].each do |month, _|
        data[year][month].each do |area, _|
          data[year][month][area].each do |prefecture, v|
            if data[year][month - 1]
              w = data[year][month - 1][area][prefecture]
              v[:v0] ||= v[:v3] - w[:v3]
              v[:v1] ||= v[:v4] - w[:v4]
              v[:v2] ||= v[:v5] - w[:v5]
            end
          end
        end
      end
    end
  end
end



