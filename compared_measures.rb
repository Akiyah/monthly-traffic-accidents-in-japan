require './measures.rb'

class ComparedMeasures
  attr_accessor :v0, :v1, :v2, :v3, :v4, :v5, :v0_, :v1_, :v2_, :v3_, :v4_, :v5_
  attr_accessor :measures
  attr_accessor :measures_in_year
  attr_accessor :measures_change
  attr_accessor :measures_change_in_year

  def self.map_sheet_row(sheet_in_month, sheet_in_year, columns)
    self.create_from_block do |measures_key, v_key|
      if [:measures, :measures_change].include?(measures_key)
        sheet = sheet_in_month
      else
        sheet = sheet_in_year
      end

      if [:measures, :measures_in_year].include?(measures_key)
        column = columns[:measures][v_key]
      else
        column = columns[:measures_change][v_key]
      end

      next nil unless sheet
      next nil unless column
      yield(sheet, column)
    end
  end

  def self.sum(prefectures)
    self.create_from_block do |measures_key, v_key|
      next nil unless prefectures.all? { |prefecture, m| m.send(measures_key).send(v_key) }
      prefectures.sum { |prefecture, m| m.send(measures_key).send(v_key) }
    end
  end

  def self.create_from_block
    a = [
      :measures,
      :measures_in_year,
      :measures_change,
      :measures_change_in_year,
    ].map do |measures_key|
      [:v0, :v1, :v2].map do |v_key|
        yield(measures_key, v_key)
      end
    end.flatten

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

  def self.create_by_measures(measures, measures_in_year, measures_change = Measures.new(nil, nil, nil), measures_change_in_year = Measures.new(nil, nil, nil))
    cm = ComparedMeasures.new(nil, nil, nil, nil, nil, nil)
    cm.measures = measures
    cm.measures_in_year = measures_in_year
    cm.measures_change = measures_change
    cm.measures_change_in_year = measures_change_in_year

    cm.initialize_vs
    cm
  end

  def initialize_vs
    @v0 = @measures.v0
    @v1 = @measures.v1
    @v2 = @measures.v2
    @v3 = @measures_in_year.v0
    @v4 = @measures_in_year.v1
    @v5 = @measures_in_year.v2
    @v0_ = @measures_change.v0
    @v1_ = @measures_change.v1
    @v2_ = @measures_change.v2
    @v3_ = @measures_change_in_year.v0
    @v4_ = @measures_change_in_year.v1
    @v5_ = @measures_change_in_year.v2
  end

  def to_a
    @measures.to_a + @measures_in_year.to_a + @measures_change.to_a + @measures_change_in_year.to_a
  end

  def diff345to123(cm1)
    cm2 = self.dup
    if cm2.measures.empty? && !cm2.measures_in_year.empty? && !cm1.measures_in_year.empty?
      cm2.measures = cm2.measures_in_year.diff(cm1.measures_in_year)
    end
    if cm2.measures_change.empty? && !cm2.measures_change_in_year.empty? && !cm1.measures_change_in_year.empty?
      cm2.measures_change = cm2.measures_change_in_year.diff(cm1.measures_change_in_year)
    end
    cm2.initialize_vs
    cm2
  end

  def diff012345to_
    return nil if @measures_change.empty? || @measures_change_in_year.empty?

    ComparedMeasures.create_by_measures(
      @measures.diff(@measures_change),
      @measures_in_year.diff(@measures_change_in_year)
    )
  end

  def create_next_month_from_next_next_month(cm2)
    ComparedMeasures.create_by_measures(
      cm2.measures_in_year.diff(cm2.measures).diff(measures_in_year),
      cm2.measures_in_year.diff(cm2.measures)
    )
  end
end
