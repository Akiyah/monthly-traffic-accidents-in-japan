require 'open-uri'

class Downloader
  def initialize(path)
    @path = path
  end

  def filename_xls(year, month, i = nil)
    filename('xls', year, month, i)
  end

  def filename_xlsx(year, month, i = nil)
    filename('xlsx', year, month, i)
  end

  def filename(extension, year, month, i = nil)
    if i
      "%s/%d_%02d_%d.%s" % [@path, year, month, i, extension]
    else
      "%s/%d_%02d.%s" % [@path, year, month, extension]
    end
  end

  def download(year, month, urls)
    if urls.instance_of?(Array)
      urls.map.with_index do |url, i|
        download_one(year, month, url, i)
      end
    end

    download_one(year, month, urls)
  end

  def download_one(year, month, url, i = nil)
    return filename_xls(year, month, i) if File.exist?(filename_xls(year, month, i))
    return filename_xlsx(year, month, i) if File.exist?(filename_xlsx(year, month, i))

    URI.open(url) do |stream|
      content_disposition = stream.meta["content-disposition"]
      filename = if content_disposition.end_with?('.xls')
        filename_xls(year, month, i)
      else
        filename_xlsx(year, month, i)
      end
      puts "download: #{filename}"
      open(filename, 'w+b') do |file|
        file.write(stream.read)
      end
      filename
    end
  end
end
