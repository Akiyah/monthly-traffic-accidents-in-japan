require './measures.rb'

class ComparedMeasures
  def self.map_sheet_row(sheet_in_month, sheet_in_year, columns)
    self.create_from_block do |term, type, v_key|
      sheet = sheets[term]
      column = columns[type][v_key]

      next nil unless sheet
      next nil unless column
      yield(sheet, column)
    end
  end

  def self.sum(prefectures)
    self.create_from_block do |term, type, v_key|
      next nil unless prefectures.all? { |prefecture, m| m.get(term, type).send(v_key) }
      prefectures.sum { |prefecture, m| m.get(term, type).send(v_key) }
    end
  end

  def self.create_from_block
    ComparedMeasures.new(
      Measures.create_from_block { |v_key| yield(:monthly, :value, v_key) },
      Measures.create_from_block { |v_key| yield(:yearly, :value, v_key) },
      Measures.create_from_block { |v_key| yield(:monthly, :change, v_key) },
      Measures.create_from_block { |v_key| yield(:yearly, :change, v_key) }
    )
  end

  def self.create_from_a(a)
    ComparedMeasures.new(
      Measures.new(*a[0..2]),
      Measures.new(*a[3..5]),
      Measures.new(*a[6..8]),
      Measures.new(*a[9..11])
    )
  end

  def initialize(monthly_value, yearly_value, monthly_change = nil, yearly_change = nil)
    @measures = {
      monthly: {
        value: monthly_value,
        change: monthly_change || Measures.new(nil, nil, nil)
      },
      yearly: {
        value: yearly_value,
        change: yearly_change || Measures.new(nil, nil, nil)
      }
    }
  end

  def to_a
    [:value, :change].map do |type|
      [:monthly, :yearly].map do |term|
        get(term, type).to_a
      end
    end.flatten
  end

  def get(term, type)
    @measures[term][type]
  end

  def set(term, type, m)
    @measures[term][type] = m
  end

  def monthly_value; get(:monthly, :value); end
  def yearly_value; get(:yearly, :value); end
  def monthly_change; get(:monthly, :change); end
  def yearly_change; get(:yearly, :change); end

  def monthly_value=(m); set(:monthly, :value, m); end
  def yearly_value=(m); set(:yearly, :value, m); end
  def monthly_change=(m); set(:monthly, :change, m); end
  def yearly_change=(m); set(:yearly, :change, m); end

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
    return nil if monthly_change.empty? || yearly_change.empty?

    ComparedMeasures.new(
      monthly_value - monthly_change,
      yearly_value - yearly_change
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
