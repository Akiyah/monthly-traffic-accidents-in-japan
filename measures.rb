class Measures
  attr_reader :v0, :v1, :v2

  def initialize(v0 = nil, v1 = nil, v2 = nil)
    @v0 = v0 ? v0.to_i : nil
    @v1 = v1 ? v1.to_i : nil
    @v2 = v2 ? v2.to_i : nil
  end

  def to_a
    [@v0, @v1, @v2]
  end

  def empty?
    to_a.any? { |v| !v }
  end

  def to_h
    {
      v0: @v0,
      v1: @v1,
      v2: @v2
    }
  end

  def diff(m1)
    return nil if !m1 || empty? || m1.empty?
    Measures.new(@v0 - m1.v0, @v1 - m1.v1, @v2 - m1.v2)
  end
end
