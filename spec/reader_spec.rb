require './lib/reader.rb'

RSpec.describe Reader do
  context "#read" do
    let(:result) { {} }

    before do
      if File.exist?(path)
        reader.read(path) do |area, prefecture, cm|
          result[area] ||= {}
          result[area][prefecture] = cm
        end
      end
    end

    context "A1" do
      let(:reader) { Reader.create('A1') }
      let(:path) { './download/xls/2020_05.xlsx' }
      let(:expected) do
        [
          18107, 194, 21562,
          121641, 1155, 145253,
          -12432, -16, -15840,
          -36652, -57, -46593
        ]
      end

      it do
        expect(result['合計']['計'].to_a).to eq expected if File.exist?(path)
      end
    end

    context "A2" do
      let(:reader) { Reader.create('A2') }
      let(:path) { './download/xls/2019_12.xlsx' }
      let(:expected) do
        [
          nil, nil, nil,
          381237, 3215, 461775,
          nil, nil, nil,
          -49364, -317, -64071
        ]
      end

      it do
        expect(result['合計']['計'].to_a).to eq expected if File.exist?(path)
      end
    end

    context "A3" do
      let(:reader) { Reader.create('A3') }
      let(:path) { './download/xls/2018_11.xls' }
      let(:expected) do
        [
          37203, 326, 44925,
          390471, 3122, 476878,
          -3036, -46, -3855,
          -36841, -191, -49091
        ]
      end

      it do
        expect(result['合計']['計'].to_a).to eq expected if File.exist?(path)
      end
    end

    context "A4" do
      let(:reader) { Reader.create('A4') }
      let(:path) { './download/xls/2018_01.xls' }
      let(:expected) do
        [
          34599, 319, 42444,
          34599, 319, 42444,
          -3121, 37, -3979,
          -3121, 37, -3979
        ]
      end

      it do
        expect(result['合計']['計'].to_a).to eq expected if File.exist?(path)
      end
    end

    context "B1" do
      let(:reader) { Reader.create('B1') }
      let(:path) { './download/xls/2018_12.xls' }
      let(:expected) do
        [
          nil, nil, nil,
          430601, 3532, 525846,
          nil, nil, nil,
          nil, nil, nil
        ]
      end

      it do
        expect(result['合計']['計'].to_a).to eq expected if File.exist?(path)
      end
    end

    context "B2" do
      let(:reader) { Reader.create('B2') }
      let(:path) { './download/xls/2017_06.xls' }
      let(:expected) do
        [
          nil, nil, nil,
          230351, 1675, 283114,
          nil, nil, nil,
          nil, nil, nil
        ]
      end

      it do
        expect(result['合計']['計'].to_a).to eq expected if File.exist?(path)
      end
    end

    context "B3" do
      let(:reader) { Reader.create('B3') }
      let(:path) { './download/xls/2015_12.xls' }
      let(:expected) do
        [
          nil, nil, nil,
          536899, 4117, 666023,
          nil, nil, nil,
          nil, nil, nil
        ]
      end

      it do
        expect(result['合計']['計'].to_a).to eq expected if File.exist?(path)
      end
    end
  end
end
