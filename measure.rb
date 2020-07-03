class Measure
  def self.a_to_h(v)
    self.map_to_h do |k, i|
      v[i] ? v[i].to_i : nil
    end
  end

  def self.h_to_a(v)
    %i(v0 v1 v2 v3 v4 v5 v0_ v1_ v2_ v3_ v4_ v5_).map { |k| v[k] }
  end

  def self.h_to_a3(v)
    self.h_to_a(v)[0..2]
  end

  def self.map_to_h
    %i(v0 v1 v2 v3 v4 v5 v0_ v1_ v2_ v3_ v4_ v5_).map.with_index do |k, i|
      [k, yield(k, i)]
    end.to_h
  end

  def self.map_sheet_row(sheet0, sheet1, columns)
    self.map_to_h do |k, j|
      if %i(v0 v1 v2 v0_ v1_ v2_).include?(k)
        sheet = sheet0
      else
        sheet = sheet1
      end
      column_key = %i(v0 v1 v2 v0 v1 v2 v0_ v1_ v2_ v0_ v1_ v2_)[j]
      column = columns[column_key]
      yield(sheet, column)
    end
  end

  def self.sum(prefectures)
    self.map_to_h do |k, j|
      next nil unless prefectures.all? { |prefecture, x| x[k] }
      prefectures.sum { |prefecture, x| x[k] }
    end
  end

  def initialize(v0, v1, v2, v3, v4, v5, v0_, v1_, v2_, v3_, v4_, v5_)
    @v0 = v0
    @v1 = v1
    @v2 = v2
    @v3 = v3
    @v4 = v4
    @v5 = v5
    @v0_ = v0_
    @v1_ = v1_
    @v2_ = v2_
    @v3_ = v3_
    @v4_ = v4_
    @v5_ = v5_
  end
end
