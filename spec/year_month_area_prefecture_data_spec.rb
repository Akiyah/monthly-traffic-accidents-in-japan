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
