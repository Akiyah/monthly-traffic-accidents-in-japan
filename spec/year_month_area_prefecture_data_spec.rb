require './lib/year_month_area_prefecture_data.rb'

RSpec.describe YearMonthAreaPrefectureData do
  let(:data) { YearMonthAreaPrefectureData.new('spec/download/tsv', 'spec/download/xls') }

  context "#get & #set" do
    it do
      data.set(2020, 5, 'area1', 'prefecture1', 'cm1')
      data.set(2020, 5, 'area1', 'prefecture2', 'cm2')
      data.set(2020, 5, 'area2', 'prefecture1', 'cm3')
      data.set(2020, 4, 'area1', 'prefecture1', 'cm4')
      data.set(2019, 5, 'area1', 'prefecture1', 'cm5')

      expect(data.get(2020, 5, 'area1', 'prefecture1')).to eq 'cm1'
      expect(data.get(2020, 5, 'area1', 'prefecture2')).to eq 'cm2'
      expect(data.get(2020, 5, 'area2', 'prefecture1')).to eq 'cm3'
      expect(data.get(2020, 4, 'area1', 'prefecture1')).to eq 'cm4'
      expect(data.get(2019, 5, 'area1', 'prefecture1')).to eq 'cm5'
    end

    context "#set_if_nil" do
      it do
        data.set_if_nil(2020, 5, 'area1', 'prefecture1', 'cm41')
        expect(data.get(2020, 5, 'area1', 'prefecture1')).to eq 'cm41'

        data.set_if_nil(2020, 5, 'area1', 'prefecture1', 'cm42')
        expect(data.get(2020, 5, 'area1', 'prefecture1')).to eq 'cm41'

        data.set(2020, 5, 'area1', 'prefecture1', 'cm43')
        expect(data.get(2020, 5, 'area1', 'prefecture1')).to eq 'cm43'
      end
    end
  end

  context "#each" do
    before do
      data.set(2020, 5, 'area1', 'prefecture1', 'cm1')
      data.set(2020, 5, 'area1', 'prefecture2', 'cm2')
      data.set(2020, 5, 'area2', 'prefecture1', 'cm3')
      data.set(2020, 4, 'area1', 'prefecture1', 'cm4')
      data.set(2019, 5, 'area1', 'prefecture1', 'cm5')
    end

    it do
      result = []
      data.each do |year, month, area, prefecture, cm|
        result << [year, month, area, prefecture, cm]
      end

      expect(result).to eq [
        [2020, 5, 'area1', 'prefecture1', 'cm1'],
        [2020, 5, 'area1', 'prefecture2', 'cm2'],
        [2020, 5, 'area2', 'prefecture1', 'cm3'],
        [2020, 4, 'area1', 'prefecture1', 'cm4'],
        [2019, 5, 'area1', 'prefecture1', 'cm5']
      ]
    end
  end

  context "#each_ym" do
    before do
      data.set(2020, 5, 'area1', 'prefecture1', 'cm1')
      data.set(2020, 5, 'area1', 'prefecture2', 'cm2')
      data.set(2020, 5, 'area2', 'prefecture1', 'cm3')
      data.set(2020, 4, 'area1', 'prefecture1', 'cm4')
      data.set(2019, 5, 'area1', 'prefecture1', 'cm5')
    end
    
    it do
      result = []
      data.each_ym(2020, 5) do |area, prefecture, cm|
        result << [area, prefecture, cm]
      end

      expect(result).to eq [
        ['area1', 'prefecture1', 'cm1'],
        ['area1', 'prefecture2', 'cm2'],
        ['area2', 'prefecture1', 'cm3'],
      ]
    end
  end

  context "#each_year_month_area" do
    before do
      data.set(2020, 5, 'area1', 'prefecture1', 'cm1')
      data.set(2020, 5, 'area1', 'prefecture2', 'cm2')
      data.set(2020, 5, 'area2', 'prefecture1', 'cm3')
      data.set(2020, 4, 'area1', 'prefecture1', 'cm4')
      data.set(2019, 5, 'area1', 'prefecture1', 'cm5')
    end
      
    it do
      result = []
      data.each_year_month_area do |year, month, area, prefectures|
        result << [year, month, area, prefectures]
      end

      expect(result).to eq [
        [2020, 5, 'area1', { 'prefecture1' => 'cm1', 'prefecture2' => 'cm2' }],
        [2020, 5, 'area2', { 'prefecture1' => 'cm3' }],
        [2020, 4, 'area1', { 'prefecture1' => 'cm4' }],
        [2019, 5, 'area1', { 'prefecture1' => 'cm5' }]
      ]
    end
  end

  context "#fill" do
    let(:cm_2019_5) { ComparedMeasures.create_from_a([20, 10, 30, 20*5, 10*5, 30*5, 4, 2, 6, 4*5, 2*5, 6*5]) }
    let(:cm_2019_6) { ComparedMeasures.create_from_a([nil, nil, nil, 20*6, 10*6, 30*6, nil, nil, nil, 4*6, 2*6, 6*6]) }
    let(:cm_2019_7) { ComparedMeasures.create_from_a([20, 10, 30, 20*7, 10*7, 30*7, 4, 2, 6, 4*7, 2*7, 6*7]) }
    let(:cm_2019_9) { ComparedMeasures.create_from_a([20, 10, 30, 20*9, 10*9, 30*9, 4, 2, 6, 4*9, 2*9, 6*9]) }

    before do
      data.set(2019, 5, 'area1', 'prefecture1', cm_2019_5)
      data.set(2019, 6, 'area1', 'prefecture1', cm_2019_6)
      data.set(2019, 7, 'area1', 'prefecture1', cm_2019_7)
      data.set(2019, 9, 'area1', 'prefecture1', cm_2019_9)
    end

    let(:expected) do
      [
        [2019, 5, "area1", "prefecture1", [20, 10, 30, 20*5, 10*5, 30*5, 4, 2, 6, 4*5, 2*5, 6*5]],
        [2019, 5, "area1", "計",          [20, 10, 30, 20*5, 10*5, 30*5, 4, 2, 6, 4*5, 2*5, 6*5]],
        [2019, 6, "area1", "prefecture1", [20, 10, 30, 20*6, 10*6, 30*6, 4, 2, 6, 4*6, 2*6, 6*6]],
        [2019, 6, "area1", "計",          [20, 10, 30, 20*6, 10*6, 30*6, 4, 2, 6, 4*6, 2*6, 6*6]],
        [2019, 7, "area1", "prefecture1", [20, 10, 30, 20*7, 10*7, 30*7, 4, 2, 6, 4*7, 2*7, 6*7]],
        [2019, 7, "area1", "計",          [20, 10, 30, 20*7, 10*7, 30*7, 4, 2, 6, 4*7, 2*7, 6*7]],
        [2019, 9, "area1", "prefecture1", [20, 10, 30, 20*9, 10*9, 30*9, 4, 2, 6, 4*9, 2*9, 6*9]],
        [2019, 9, "area1", "計",          [20, 10, 30, 20*9, 10*9, 30*9, 4, 2, 6, 4*9, 2*9, 6*9]],
        [2019, 8, "area1", "prefecture1", [20, 10, 30, 20*8, 10*8, 30*8, nil, nil, nil, nil, nil, nil]],
        [2019, 8, "area1", "計",          [20, 10, 30, 20*8, 10*8, 30*8, nil, nil, nil, nil, nil, nil]],
        [2018, 5, "area1", "prefecture1", [16, 8, 24, 80, 40, 120, nil, nil, nil, nil, nil, nil]],
        [2018, 5, "area1", "計",          [16, 8, 24, 80, 40, 120, nil, nil, nil, nil, nil, nil]],
        [2018, 6, "area1", "prefecture1", [16, 8, 24, 96, 48, 144, nil, nil, nil, nil, nil, nil]],
        [2018, 6, "area1", "計",          [16, 8, 24, 96, 48, 144, nil, nil, nil, nil, nil, nil]],
        [2018, 7, "area1", "prefecture1", [16, 8, 24, 112, 56, 168, nil, nil, nil, nil, nil, nil]],
        [2018, 7, "area1", "計",          [16, 8, 24, 112, 56, 168, nil, nil, nil, nil, nil, nil]],
        [2018, 9, "area1", "prefecture1", [16, 8, 24, 144, 72, 216, nil, nil, nil, nil, nil, nil]],
        [2018, 9, "area1", "計",          [16, 8, 24, 144, 72, 216, nil, nil, nil, nil, nil, nil]],
        [2018, 8, "area1", "prefecture1", [16, 8, 24, 128, 64, 192, nil, nil, nil, nil, nil, nil]],
        [2018, 8, "area1", "計",          [16, 8, 24, 128, 64, 192, nil, nil, nil, nil, nil, nil]]
      ]
    end

    it do
      data.fill

      i = 0
      data.each do |year, month, area, prefecture, cm|
        expect([year, month, area, prefecture, cm.to_a]).to eq expected[i]
        i += 1
      end
    end
  end

  context "#write" do
    let(:cm1) { ComparedMeasures.create_from_a((1..12).to_a) }
    let(:cm2) { ComparedMeasures.create_from_a((2..13).to_a) }
    let(:cm3) { ComparedMeasures.create_from_a((3..14).to_a) }
    let(:cm4) { ComparedMeasures.create_from_a((4..15).to_a) }
    let(:cm5) { ComparedMeasures.create_from_a((5..16).to_a) }

    before do
      data.set(2020, 5, 'area1', 'prefecture1', cm1)
      data.set(2020, 5, 'area1', 'prefecture2', cm2)
      data.set(2020, 5, 'area2', 'prefecture1', cm3)
      data.set(2020, 4, 'area1', 'prefecture1', cm4)
      data.set(2019, 5, 'area1', 'prefecture1', cm5)
    end

    it do
      data.write('spec/tsv/monthly-traffic-accidents-in-japan.tsv')

      result = File.read("spec/tsv/monthly-traffic-accidents-in-japan.tsv")
      expected = File.read("spec/tsv/monthly-traffic-accidents-in-japan_expected.tsv")
      expect(result).to eq expected
    end
  end
end
