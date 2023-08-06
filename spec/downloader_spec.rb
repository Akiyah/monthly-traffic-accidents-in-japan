require './lib/downloader.rb'

RSpec.describe Downloader do
  let(:downloader) { Downloader.new('download/xls') }

  describe "#filename_xls" do
    it do
      expect(downloader.filename_xls(2023, 7)).to eq 'download/xls/2023_07.xls'
      expect(downloader.filename_xls(2023, 7, 0)).to eq 'download/xls/2023_07_0.xls'
      expect(downloader.filename_xls(2023, 7, 1)).to eq 'download/xls/2023_07_1.xls'
    end
  end

  describe "#filename_xlsx" do
    it do
      expect(downloader.filename_xlsx(2023, 7)).to eq 'download/xls/2023_07.xlsx'
      expect(downloader.filename_xlsx(2023, 7, 0)).to eq 'download/xls/2023_07_0.xlsx'
      expect(downloader.filename_xlsx(2023, 7, 1)).to eq 'download/xls/2023_07_1.xlsx'
    end
  end

  describe "#filename" do
    it do
      expect(downloader.filename('ext', 2023, 7)).to eq 'download/xls/2023_07.ext'
      expect(downloader.filename('ext', 2023, 7, 0)).to eq 'download/xls/2023_07_0.ext'
      expect(downloader.filename('ext', 2023, 7, 1)).to eq 'download/xls/2023_07_1.ext'
    end
  end

  describe "#download" do
    context "urlが単数の場合" do
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

    context "urlが複数の場合" do
      let(:stream1) { double(OpenURI::Meta)}
      let(:stream2) { double(OpenURI::Meta)}
      let(:file1) { instance_double(File) }
      let(:file2) { instance_double(File) }

      before do
        allow(File).to receive(:exist?).with('download/xls/2023_07_0.xls').and_return(true)
        allow(File).to receive(:exist?).with('download/xls/2023_07_0.xlsx').and_return(false)
        allow(File).to receive(:exist?).with('download/xls/2023_07_1.xls').and_return(false)
        allow(File).to receive(:exist?).with('download/xls/2023_07_1.xlsx').and_return(false)
        allow(File).to receive(:exist?).with('download/xls/2023_07_2.xls').and_return(false)
        allow(File).to receive(:exist?).with('download/xls/2023_07_2.xlsx').and_return(false)
        allow(File).to receive(:exist?).with('download/xls/2023_07_3.xls').and_return(false)
        allow(File).to receive(:exist?).with('download/xls/2023_07_3.xlsx').and_return(true)

        allow(stream1).to receive(:read).and_return('stream content 1')
        allow(stream2).to receive(:read).and_return('stream content 2')

        allow(file1).to receive(:write)
        allow(file2).to receive(:write)

        allow(URI).to receive(:open).with('url1').and_yield(stream1)
        allow(URI).to receive(:open).with('url2').and_yield(stream2)

        allow(stream1).to receive(:meta).and_return({ "content-disposition" => 'filename.xls' })
        allow(stream2).to receive(:meta).and_return({ "content-disposition" => 'filename.xlsx' })

        expect_any_instance_of(Kernel).to receive(:open).with('download/xls/2023_07_1.xls', 'w+b').and_yield(file1)
        expect_any_instance_of(Kernel).to receive(:open).with('download/xls/2023_07_2.xlsx', 'w+b').and_yield(file2)
      end

      it do
        expect(file1).to receive(:write).with('stream content 1')
        expect(file2).to receive(:write).with('stream content 2')
        expect(downloader.download(2023, 7, ['url0', 'url1', 'url2', 'url3'])).to eq [
          'download/xls/2023_07_0.xls',
          'download/xls/2023_07_1.xls',
          'download/xls/2023_07_2.xlsx',
          'download/xls/2023_07_3.xlsx'
        ]
      end
    end
  end
end
