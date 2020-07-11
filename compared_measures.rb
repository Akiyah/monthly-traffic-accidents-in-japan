require './measures.rb'

class ComparedMeasures
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
    measures = Measures.create_from_block do |v_key|
      yield(:measures, v_key)
    end

    measures_in_year = Measures.create_from_block do |v_key|
      yield(:measures_in_year, v_key)
    end

    measures_change = Measures.create_from_block do |v_key|
      yield(:measures_change, v_key)
    end

    measures_change_in_year = Measures.create_from_block do |v_key|
      yield(:measures_change_in_year, v_key)
    end

    ComparedMeasures.new(
      measures,
      measures_in_year,
      measures_change,
      measures_change_in_year
    )
  end

  def self.create_from_a(a)
    v0, v1, v2, v3, v4, v5, v0_, v1_, v2_, v3_, v4_, v5_ = a

    ComparedMeasures.new(
      Measures.new(v0, v1, v2),
      Measures.new(v3, v4, v5),
      Measures.new(v0_, v1_, v2_),
      Measures.new(v3_, v4_, v5_)
    )
  end

  def initialize(measures, measures_in_year, measures_change = nil, measures_change_in_year = nil)
    @measures = measures
    @measures_in_year = measures_in_year
    @measures_change = measures_change || Measures.new(nil, nil, nil)
    @measures_change_in_year = measures_change_in_year || Measures.new(nil, nil, nil)
  end

  def to_a
    @measures.to_a + @measures_in_year.to_a + @measures_change.to_a + @measures_change_in_year.to_a
  end

  def fill_measures(cm1)
    cm2 = self.dup
    if cm2.measures.empty? && !cm2.measures_in_year.empty? && !cm1.measures_in_year.empty?
      cm2.measures = cm2.measures_in_year - cm1.measures_in_year
    end
    if cm2.measures_change.empty? && !cm2.measures_change_in_year.empty? && !cm1.measures_change_in_year.empty?
      cm2.measures_change = cm2.measures_change_in_year - cm1.measures_change_in_year
    end
    cm2
  end

  def last_year
    return nil if @measures_change.empty? || @measures_change_in_year.empty?

    ComparedMeasures.new(
      @measures - @measures_change,
      @measures_in_year - @measures_change_in_year
    )
  end

  def next_month(cm_next_next_month)
    ComparedMeasures.new(
      cm_next_next_month.measures_in_year - cm_next_next_month.measures - measures_in_year,
      cm_next_next_month.measures_in_year - cm_next_next_month.measures
    )
  end
end
