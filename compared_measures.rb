require './measures.rb'

class ComparedMeasures
  attr_accessor :v0, :v1, :v2, :v3, :v4, :v5, :v0_, :v1_, :v2_, :v3_, :v4_, :v5_
  attr_accessor :measures
  attr_accessor :measures_in_year
  attr_accessor :measures_change
  attr_accessor :measures_change_in_year

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

  def self.create_from_block
    a = %i(v0 v1 v2 v3 v4 v5 v0_ v1_ v2_ v3_ v4_ v5_).map.with_index do |k, i|
      yield(k, i)
    end

    ComparedMeasures.new(*a)
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

    initialize_measures
  end

  def initialize_measures
    @measures = Measures.new(v0, v1, v2)
    @measures_in_year = Measures.new(v3, v4, v5)
    @measures_change = Measures.new(v0_, v1_, v2_)
    @measures_change_in_year = Measures.new(v3_, v4_, v5_)
  end

  def to_a
    @measures.to_a + @measures_in_year.to_a + @measures_change.to_a + @measures_change_in_year.to_a
  end

  def to_h
    @measures.to_h.merge(
      {
        v3: @measures_in_year.v0,
        v4: @measures_in_year.v1,
        v5: @measures_in_year.v2,
        v0_: @measures_change.v0,
        v1_: @measures_change.v1,
        v2_: @measures_change.v2,
        v3_: @measures_change_in_year.v0,
        v4_: @measures_change_in_year.v1,
        v5_: @measures_change_in_year.v2
      }
    )
  end

  def diff345to123(cm1)
    cm2 = self.dup
    cm2.v0 ||= v3 - cm1.v3 if !v0 && v3 && cm1.v3
    cm2.v1 ||= v4 - cm1.v4 if !v1 && v4 && cm1.v4
    cm2.v2 ||= v5 - cm1.v5 if !v2 && v5 && cm1.v5
    cm2.v0_ ||= v3_ - cm1.v3_ if !v0_ && v3_ && cm1.v3_
    cm2.v1_ ||= v4_ - cm1.v4_ if !v1_ && v4_ && cm1.v4_
    cm2.v2_ ||= v5_ - cm1.v5_ if !v2_ && v5_ && cm1.v5_
    cm2.initialize_measures
    cm2
  end

  def diff012345to_
    return nil if @measures_change.empty? || @measures_change_in_year.empty?

    a = @measures.diff(@measures_change).to_a + @measures_in_year.diff(@measures_change_in_year).to_a
    ComparedMeasures.new(*a)
  end

  def create_next_month_from_next_next_month(cm2)
    a = cm2.measures_in_year.diff(cm2.measures).diff(measures_in_year).to_a + cm2.measures_in_year.diff(cm2.measures).to_a
    ComparedMeasures.new(*a)
  end
end
