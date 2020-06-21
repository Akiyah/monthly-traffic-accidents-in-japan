class Filler
  def fill(data)
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



