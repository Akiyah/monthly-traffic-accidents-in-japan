require 'open-uri'

class Downloader
  def download(year, month, url)
    Dir.mkdir('xlsx') unless Dir.exist?('xlsx')

    filename_xls = "xlsx/%d_%02d.xls" % [year, month]
    filename_xlsx = "xlsx/%d_%02d.xlsx" % [year, month]

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



