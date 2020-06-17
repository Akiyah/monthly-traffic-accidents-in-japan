require 'open-uri'
require './params.rb'

Dir.mkdir('xlsx') unless Dir.exist?('xlsx')

PARAMS.each do |param|
  year = param[:year]
  month = param[:month]
  url = param[:url]
  filename = "xlsx/#{year}_#{month}.xlsx"

  next if File.exist?(filename)

  open(url) do |stream|
    open(filename, 'w+b') do |file|
      file.write(stream.read)
    end
  end
end

