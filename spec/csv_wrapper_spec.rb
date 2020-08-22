require './lib/csv_wrapper.rb'

RSpec.describe CsvWrapper do
  context "#read" do
    context "xlsx" do
      let(:path) { 'download/xls/2020_05.xlsx' }

      it do
        if File.exist?(path)
          csv_wrapper = CsvWrapper.new(path)

          expect(csv_wrapper.read('表2-5',  7, 'C')).to eq "2"
          expect(csv_wrapper.read('表2-5',  7, 'M')).to eq "1"
          expect(csv_wrapper.read('表2-5', 40, 'C')).to eq "0"
          expect(csv_wrapper.read('表2-6',  7, 'C')).to eq "57"
        end
      end
    end

    context "xls" do
      let(:path) { 'download/xls/2018_12.xls' }

      it do
        if File.exist?(path)
          csv_wrapper = CsvWrapper.new(path)

          expect(csv_wrapper.read('県別人口（P41）',  6, 'I')).to eq "9931"
          expect(csv_wrapper.read('県別人口（P41）',  6, 'J')).to eq "141"
          expect(csv_wrapper.read('県別人口（P41）', 53, 'I')).to eq "430601"
          expect(csv_wrapper.read('県別人口（P41）',  6, 'I')).to eq "9931"
        end
      end
    end
  end
end
