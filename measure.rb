class Measure
  attr_accessor :v0, :v1, :v2, :v3, :v4, :v5, :v0_, :v1_, :v2_, :v3_, :v4_, :v5_

  def self.a_to_h(a)
    Measure.new(*a).to_h
  end

  def self.h_to_a(h)
    Measure.create_from_h(h).to_a
  end

  def self.map_sheet_row(sheet0, sheet1, columns)
    self.create_from_block do |k, i|
      if %i(v0 v1 v2 v0_ v1_ v2_).include?(k)
        sheet = sheet0
      else
        sheet = sheet1
      end
      column_key = %i(v0 v1 v2 v0 v1 v2 v0_ v1_ v2_ v0_ v1_ v2_)[i]
      column = columns[column_key]
      next nil unless sheet
      next nil unless column
      yield(sheet, column)
    end
  end

  def self.sum(prefectures)
    self.create_from_block do |k, i|
      next nil unless prefectures.all? { |prefecture, m| m.send(k) }
      prefectures.sum { |prefecture, m| m.send(k) }
    end
  end

  def self.create_from_h(h)
    self.create_from_block do |k, i|
      h[k]
    end
  end

  def self.create_from_block
    a = %i(v0 v1 v2 v3 v4 v5 v0_ v1_ v2_ v3_ v4_ v5_).map.with_index do |k, i|
      yield(k, i)
    end

    Measure.new(*a)
  end

  def initialize(v0, v1, v2, v3, v4, v5, v0_=nil, v1_=nil, v2_=nil, v3_=nil, v4_=nil, v5_=nil)
    @v0 = v0 ? v0.to_i : nil
    @v1 = v1 ? v1.to_i : nil
    @v2 = v2 ? v2.to_i : nil
    @v3 = v3 ? v3.to_i : nil
    @v4 = v4 ? v4.to_i : nil
    @v5 = v5 ? v5.to_i : nil
    @v0_ = v0_ ? v0_.to_i : nil
    @v1_ = v1_ ? v1_.to_i : nil
    @v2_ = v2_ ? v2_.to_i : nil
    @v3_ = v3_ ? v3_.to_i : nil
    @v4_ = v4_ ? v4_.to_i : nil
    @v5_ = v5_ ? v5_.to_i : nil
  end

  def to_a
    [@v0, @v1, @v2, @v3, @v4, @v5, @v0_, @v1_, @v2_, @v3_, @v4_, @v5_]
  end

  def empty?
    to_a.all? { |v| !v }
  end

  def to_h
    {
      v0: @v0,
      v1: @v1,
      v2: @v2,
      v3: @v3,
      v4: @v4,
      v5: @v5,
      v0_: @v0_,
      v1_: @v1_,
      v2_: @v2_,
      v3_: @v3_,
      v4_: @v4_,
      v5_: @v5_
    }
  end

  def diff345to123(m1)
    m2 = self.dup
    m2.v0 ||= v3 - m1.v3 if !v0 && v3 && m1.v3
    m2.v1 ||= v4 - m1.v4 if !v1 && v4 && m1.v4
    m2.v2 ||= v5 - m1.v5 if !v2 && v5 && m1.v5
    m2.v0_ ||= v3_ - m1.v3_ if !v0_ && v3_ && m1.v3_
    m2.v1_ ||= v4_ - m1.v4_ if !v1_ && v4_ && m1.v4_
    m2.v2_ ||= v5_ - m1.v5_ if !v2_ && v5_ && m1.v5_
    m2
  end

  def diff012345to_
    return nil unless v0_ && v1_ && v2_ && v3_ && v4_ && v5_
    Measure.new(
      v0 - v0_,
      v1 - v1_,
      v2 - v2_,
      v3 - v3_,
      v4 - v4_,
      v5 - v5_
    )
  end

  def create_next_month_from_next_next_month(m2)
    Measure.new(
      m2.v3 - m2.v0 - v3,
      m2.v4 - m2.v1 - v4,
      m2.v5 - m2.v2 - v5,
      m2.v3 - m2.v0,
      m2.v4 - m2.v1,
      m2.v5 - m2.v2
    )
  end
end
