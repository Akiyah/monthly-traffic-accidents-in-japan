require 'open-uri'

class Downloader
  def download(year, month, ext, url)
    Dir.mkdir('xlsx') unless Dir.exist?('xlsx')

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



