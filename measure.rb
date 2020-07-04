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

  def self.diff345to123(m, m1)
    m[:v0] ||= m[:v3] - m1[:v3] if !m[:v0] && m[:v3] && m1[:v3]
    m[:v1] ||= m[:v4] - m1[:v4] if !m[:v1] && m[:v4] && m1[:v4]
    m[:v2] ||= m[:v5] - m1[:v5] if !m[:v2] && m[:v5] && m1[:v5]
    m[:v0_] ||= m[:v3_] - m1[:v3_] if !m[:v0_] && m[:v3_] && m1[:v3_]
    m[:v1_] ||= m[:v4_] - m1[:v4_] if !m[:v1_] && m[:v4_] && m1[:v4_]
    m[:v2_] ||= m[:v5_] - m1[:v5_] if !m[:v2_] && m[:v5_] && m1[:v5_]
  end

  def self.diff012345to_(m)
    return nil unless %i(v0_ v1_ v2_ v3_ v4_ v5_).all? { |k| m[k] }
    {
      v0: m[:v0] - m[:v0_],
      v1: m[:v1] - m[:v1_],
      v2: m[:v2] - m[:v2_],
      v3: m[:v3] - m[:v3_],
      v4: m[:v4] - m[:v4_],
      v5: m[:v5] - m[:v5_],
      v0_: nil,
      v1_: nil,
      v2_: nil,
      v3_: nil,
      v4_: nil,
      v5_: nil,
    }
  end

  def self.create_next_month_from_this_month_and_next_next_month(m, m2)
    v3 = m2[:v3] - m2[:v0]
    v4 = m2[:v4] - m2[:v1]
    v5 = m2[:v5] - m2[:v2]
    v0 = v3 - m[:v3]
    v1 = v4 - m[:v4]
    v2 = v5 - m[:v5]

    {
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
