require './measures.rb'

class ComparedMeasures
  attr_accessor :monthly_value
  attr_accessor :yearly_value
  attr_accessor :monthly_change
  attr_accessor :yearly_change

  def self.map_sheet_row(sheet_in_month, sheet_in_year, columns)
    self.create_from_block do |measures_key, v_key|
      if [:monthly_value, :monthly_change].include?(measures_key)
        sheet = sheet_in_month
      else
        sheet = sheet_in_year
      end

      if [:monthly_value, :yearly_value].include?(measures_key)
        column = columns[:value][v_key]
      else
        column = columns[:change][v_key]
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
    monthly_value = Measures.create_from_block do |v_key|
      yield(:monthly_value, v_key)
    end

    yearly_value = Measures.create_from_block do |v_key|
      yield(:yearly_value, v_key)
    end

    monthly_change = Measures.create_from_block do |v_key|
      yield(:monthly_change, v_key)
    end

    yearly_change = Measures.create_from_block do |v_key|
      yield(:yearly_change, v_key)
    end

    ComparedMeasures.new(
      monthly_value,
      yearly_value,
      monthly_change,
      yearly_change
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

  def initialize(monthly_value, yearly_value, monthly_change = nil, yearly_change = nil)
    @monthly_value = monthly_value
    @yearly_value = yearly_value
    @monthly_change = monthly_change || Measures.new(nil, nil, nil)
    @yearly_change = yearly_change || Measures.new(nil, nil, nil)

    @measures_hash = {
      monthly: {
        value: monthly_value,
        change: @monthly_change
      },
      yearly: {
        value: @yearly_value,
        change: @yearly_change
      }
    }
  end

  def to_a
    [:value, :change].map do |type|
      [:monthly, :yearly].map do |term|
        find_measures(term: term, type: type).to_a
      end
    end.flatten
  end

  def find_measures(term: :monthly, type: :value)
    #return @measures_hash[term][type]

    if term == :monthly
      if type == :value
        @monthly_value
      else
        @monthly_change
      end
    else
      if type == :value
        @yearly_value
      else
        @yearly_change
      end
    end
  end

  def fill_measures(cm1)
    cm2 = self.dup
    if cm2.monthly_value.empty? && !cm2.yearly_value.empty? && !cm1.yearly_value.empty?
      cm2.monthly_value = cm2.yearly_value - cm1.yearly_value
    end
    if cm2.monthly_change.empty? && !cm2.yearly_change.empty? && !cm1.yearly_change.empty?
      cm2.monthly_change = cm2.yearly_change - cm1.yearly_change
    end
    cm2
  end

  def last_year
    return nil if @monthly_change.empty? || @yearly_change.empty?

    ComparedMeasures.new(
      @monthly_value - @monthly_change,
      @yearly_value - @yearly_change
    )
  end

  def next_month(cm_next_next_month)
    return nil unless cm_next_next_month.yearly_value && cm_next_next_month.monthly_value
    return nil if cm_next_next_month.yearly_value.empty? || cm_next_next_month.monthly_value.empty?

    ComparedMeasures.new(
      cm_next_next_month.yearly_value - cm_next_next_month.monthly_value - yearly_value,
      cm_next_next_month.yearly_value - cm_next_next_month.monthly_value
    )
  end
end
