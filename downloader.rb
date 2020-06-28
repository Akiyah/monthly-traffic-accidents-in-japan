require 'open-uri'

class Downloader
  def download(year, month, url)
    Dir.mkdir('download') unless Dir.exist?('download')
    Dir.mkdir('download/xls') unless Dir.exist?('download/xls')

    filename_xls = "download/xls/%d_%02d.xls" % [year, month]
    filename_xlsx = "download/xls/%d_%02d.xlsx" % [year, month]

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



