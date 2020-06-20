require 'open-uri'

class Downloader
  def download(param)
    Dir.mkdir('xlsx') unless Dir.exist?('xlsx')

    year = param[:year]
    month = param[:month]
    url = param[:url]
    ext = param[:ext]
    filename = "xlsx/%d_%02d.%s" % [year, month, ext]

    if !File.exist?(filename)
      open(url) do |stream|
        open(filename, 'w+b') do |file|
          file.write(stream.read)
        end
      end
    end

    filename
  end
end



