require 'fileutils'
require './lib/cacher.rb'
require './lib/year_month_area_prefecture_data.rb'

RSpec.describe Cacher do
  let(:cacher) { Cacher.new('./spec/download/tsv') }
  let(:data) { YearMonthAreaPrefectureData.new('./spec/download/tsv', './spec/download/xls') }

  before do
    ["./spec/download/tsv/2020_4.tsv", "./spec/download/tsv/2020_5.tsv"].each do |path|
      File.delete(path) if File.exist?(path)
    end
  end

  context "#exists?" do
    before do
      FileUtils.touch("./spec/download/tsv/2020_5.tsv")
    end

    it do
      expect(cacher.exists?(2020, 5)).to be_truthy
      expect(cacher.exists?(2020, 4)).to be_falsey
    end
  end

  context "#write" do
    before do
      compared_measures1 = ComparedMeasures.create_from_a((1..12).to_a)
      compared_measures2 = ComparedMeasures.create_from_a((13..24).to_a)
      data.set(2020, 4, 'area1', 'prefecture1', compared_measures1)
      data.set(2020, 4, 'area2', 'prefecture2', compared_measures2)
    end

    it do
      cacher.write(2020, 4, data)
      result = File.read("./spec/download/tsv/2020_4.tsv")
      expected = File.read("./spec/download/tsv/2020_4_expected.tsv")
      expect(result).to eq expected
    end
  end

  context "#read" do
    before do
      FileUtils.cp("./spec/download/tsv/2020_4_expected.tsv", "./spec/download/tsv/2020_4.tsv")
    end

    it do
      result = []
      cacher.read(2020, 4) do |area, prefecture, cm|
        result << [area, prefecture, cm.to_a]
      end

      expect(result).to eq [
        ["area1", "prefecture1", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]],
        ["area2", "prefecture2", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]]
      ]
    end
  end
end
