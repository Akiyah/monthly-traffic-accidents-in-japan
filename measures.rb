class Measures
  attr_reader :accidents, :fatalities, :injuries

  def self.create_from_block
    accidents = yield(:accidents)
    fatalities = yield(:fatalities)
    injuries = yield(:injuries)

    Measures.new(accidents, fatalities, injuries)
  end

  def initialize(accidents = nil, fatalities = nil, injuries = nil)
    @accidents = accidents&.to_i
    @fatalities = fatalities&.to_i
    @injuries = injuries&.to_i
  end

  def to_a
    [@accidents, @fatalities, @injuries]
  end

  def empty?
    to_a.any? { |v| !v }
  end

  def -(m1)
    return nil if !m1 || empty? || m1.empty?
    Measures.new(
      @accidents - m1.accidents,
      @fatalities - m1.fatalities,
      @injuries - m1.injuries
    )
  end
end
