require 'open-uri'

class Downloader
  def initialize(path)
    @path = path
  end

  def download(year, month, url)
    filename_xls = "%s/%d_%02d.xls" % [@path, year, month]
    filename_xlsx = "%s/%d_%02d.xlsx" % [@path, year, month]

    return filename_xls if File.exist?(filename_xls)
    return filename_xlsx if File.exist?(filename_xlsx)

    open(url) do |stream|
      content_disposition = stream.meta["content-disposition"]
      filename = if content_disposition.end_with?('.xls')
        filename_xls
      else
        filename_xlsx
      end
      puts "download: #{filename}"
      open(filename, 'w+b') do |file|
        file.write(stream.read)
      end
      filename
    end
  end
end
