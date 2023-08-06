require './lib/csv_wrapper.rb'

RSpec.describe CsvWrapper do
  context "#read" do
    context "pathが単数の場合" do
      context "xlsx" do
        let(:path) { 'spec/download/xls/2020_05.xlsx' }

        it do
          csv_wrapper = CsvWrapper.new(path)

          expect(csv_wrapper.read('表2-5',  7, 'C')).to eq "2"
          expect(csv_wrapper.read('表2-5',  7, 'M')).to eq "1"
          expect(csv_wrapper.read('表2-5', 40, 'C')).to eq "0"
          expect(csv_wrapper.read('表2-6',  7, 'C')).to eq "57"
        end
      end

      context "xls" do
        let(:path) { 'spec/download/xls/2018_12.xls' }

        it do
          csv_wrapper = CsvWrapper.new(path)

          expect(csv_wrapper.read('県別人口（P41）',  6, 'I')).to eq "9931"
          expect(csv_wrapper.read('県別人口（P41）',  6, 'J')).to eq "141"
          expect(csv_wrapper.read('県別人口（P41）', 53, 'I')).to eq "430601"
          expect(csv_wrapper.read('県別人口（P41）',  6, 'I')).to eq "9931"
          expect(csv_wrapper.read('県別高齢者人口（P42）',  7, 'I')).to eq "62"
        end
      end
    end

    context "pathが複数の場合" do
      context "xlsx" do
        let(:path) { ['spec/download/xls/2020_05_a.xlsx', 'spec/download/xls/2020_05_b.xlsx'] }

        it do
          csv_wrapper = CsvWrapper.new(path)

          expect(csv_wrapper.read('表2-5',  7, 'C')).to eq "2"
          expect(csv_wrapper.read('表2-5',  7, 'M')).to eq "1"
          expect(csv_wrapper.read('表2-5', 40, 'C')).to eq "0"
          expect(csv_wrapper.read('表2-6',  7, 'C')).to eq "57"
        end
      end

      context "xls" do
        let(:path) { ['spec/download/xls/2018_12_a.xls', 'spec/download/xls/2018_12_b.xls'] }

        it do
          csv_wrapper = CsvWrapper.new(path)

          expect(csv_wrapper.read('県別人口（P41）',  6, 'I')).to eq "9931"
          expect(csv_wrapper.read('県別人口（P41）',  6, 'J')).to eq "141"
          expect(csv_wrapper.read('県別人口（P41）', 53, 'I')).to eq "430601"
          expect(csv_wrapper.read('県別人口（P41）',  6, 'I')).to eq "9931"
          expect(csv_wrapper.read('県別高齢者人口（P42）',  7, 'I')).to eq "62"
        end
      end
    end
  end

  context "#sheet" do
    context "pathが単数の場合" do
      let(:path) { 'spec/download/xls/2020_05.xlsx' }

      it do
        csv_wrapper = CsvWrapper.new(path)

        expect(csv_wrapper.sheet('表2-5')).to_not eq nil
        expect(csv_wrapper.sheet('表2-6')).to_not eq nil
        expect(csv_wrapper.sheet('表2-7')).to_not eq nil
      end
    end

    context "pathが複数の場合" do
      let(:path) { ['spec/download/xls/2020_05_a.xlsx', 'spec/download/xls/2020_05_b.xlsx'] }

      it do
        csv_wrapper = CsvWrapper.new(path)

        expect(csv_wrapper.sheet('表2-5')).to_not eq nil
        expect(csv_wrapper.sheet('表2-6')).to_not eq nil
        expect(csv_wrapper.sheet('表2-7')).to eq nil
      end
    end
  end
end
