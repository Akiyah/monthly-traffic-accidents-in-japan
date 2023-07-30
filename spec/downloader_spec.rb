require './lib/downloader.rb'

RSpec.describe Downloader do
  let(:downloader) { Downloader.new('download/xls') }
  
  context "#download" do
    context "ファイルが存在する場合" do
      context "xlsファイルが存在する場合" do
        before do
          allow(File).to receive(:exist?).with('download/xls/2023_07.xls').and_return(true)
          allow(File).to receive(:exist?).with('download/xls/2023_07.xlsx').and_return(false)
        end

        it do
          expect(downloader.download(2023, 7, 'url')).to eq 'download/xls/2023_07.xls'
        end
      end

      context "xlsxファイルが存在する場合" do
        before do
          allow(File).to receive(:exist?).with('download/xls/2023_07.xls').and_return(false)
          allow(File).to receive(:exist?).with('download/xls/2023_07.xlsx').and_return(true)
        end

        it do
          expect(downloader.download(2023, 7, 'url')).to eq 'download/xls/2023_07.xlsx'
        end
      end
    end

    context "ファイルが存在しない場合" do
      before do
        allow(File).to receive(:exist?).with('download/xls/2023_07.xls').and_return(false)
        allow(File).to receive(:exist?).with('download/xls/2023_07.xlsx').and_return(false)
      end

      let(:stream) { double(OpenURI::Meta)}
      let(:file) { instance_double(File) }

      before do
        allow(stream).to receive(:read).and_return('stream content')
        allow(file).to receive(:write)
        allow(URI).to receive(:open).with('url').and_yield(stream)
      end

      context "xlsファイルをダウンロードする場合" do
        before do
          allow(stream).to receive(:meta).and_return({ "content-disposition" => 'filename.xls' })
          expect_any_instance_of(Kernel).to receive(:open).with('download/xls/2023_07.xls', 'w+b').and_yield(file)
        end

        it do
          expect(file).to receive(:write).with('stream content')
          expect(downloader.download(2023, 7, 'url')).to eq 'download/xls/2023_07.xls'
        end
      end

      context "xlsxファイルをダウンロードする場合" do
        before do
          allow(stream).to receive(:meta).and_return({ "content-disposition" => 'filename.xlsx' })
          expect_any_instance_of(Kernel).to receive(:open).with('download/xls/2023_07.xlsx', 'w+b').and_yield(file)
        end

        it do
          expect(file).to receive(:write).with('stream content')
          expect(downloader.download(2023, 7, 'url')).to eq 'download/xls/2023_07.xlsx'
        end
      end
    end
  end
end
