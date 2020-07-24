require './lib/measures.rb'

RSpec.describe Measures do
  context ".create_from_block" do
    it do
      measures = Measures.create_from_block do |key|
        {
          accidents: 100,
          fatalities: 50,
          injuries: 150
        }[key]    
      end

      expect(measures.accidents).to eq 100
      expect(measures.fatalities).to eq 50
      expect(measures.injuries).to eq 150
    end
  end

  context "#to_a" do
    it do
      expect(Measures.new(100, 50, 150).to_a).to eq [100, 50, 150]
    end
  end

  context "#empty?" do
    it do
      expect(Measures.new(100, 50, 150).empty?).to be_falsey
      expect(Measures.new(nil, 50, 150).empty?).to be_truthy
      expect(Measures.new(100, nil, 150).empty?).to be_truthy
      expect(Measures.new(100, 50, nil).empty?).to be_truthy
    end
  end

  context "#-" do
    it do
      measures = Measures.new(110, 55, 165) - Measures.new(100, 50, 150)

      expect(measures.accidents).to eq 10
      expect(measures.fatalities).to eq 5
      expect(measures.injuries).to eq 15
    end
  end
end
