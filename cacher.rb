require 'csv'

class Cacher
  def get(year, month)
    filename = "download/tsv/#{year}_#{month}.tsv"
    return nil unless File.exist?(filename)

    data_ym = {}
    CSV.foreach("download/tsv/#{year}_#{month}.tsv", col_sep: "\t") do |row|
      year, month, area, prefecture, *v = row
      data_ym[area] ||= {}
      data_ym[area][prefecture] = %i(v0 v1 v2 v3 v4 v5 v0_ v1_ v2_ v3_ v4_ v5_).map.with_index do |k, i|
        [k, (v[i] ? v[i].to_i : nil)]
      end.to_h
    end

    data_ym
  end

  def set(year, month, data_ym)
    Dir.mkdir('download') unless Dir.exist?('download')
    Dir.mkdir('download/tsv') unless Dir.exist?('download/tsv')

    CSV.open("download/tsv/#{year}_#{month}.tsv",'w', col_sep: "\t") do |tsv|
      data_ym.each do |area, _|
        data_ym[area].each do |prefecture, v|
          tsv << [
            year, month, area, prefecture,
            v[:v0], v[:v1], v[:v2], v[:v3], v[:v4], v[:v5],
            v[:v0_], v[:v1_], v[:v2_], v[:v3_], v[:v4_], v[:v5_]
          ]
        end
      end
    end
  end
end



