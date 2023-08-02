require 'nokogiri'
require 'json'
require 'fileutils'

class CheoScraper
  DATA_FOLDER = File.expand_path('~/cheoWaitData/').freeze
  SEPERATOR = '|'.freeze

  def get_json
    require 'open-uri'
    json = URI.open('https://www.cheo.on.ca/Common/Services/GetWaitTimes.ashx?&lang=en').read
  end

  def get_data_hash
    @data_hash ||= JSON.parse(get_json).merge(date_time: DateTime.now.to_s)
  end

  def data_file_path
    File.join(DATA_FOLDER, 'cheo_wait_times.csv')
  end

  def vasy
    setup_file
    write_data
  end

  def setup_file
    if !File.exist?(data_file_path)
      FileUtils.mkdir_p DATA_FOLDER
      write_array(get_data_hash.keys)
      puts "Initialized #{data_file_path}"
    else
      puts "File #{data_file_path} exists"
    end
  end

  def write_data
    data = get_data_hash
    write_array(data.values, mode: 'a')
    puts data
  end

  def write_array(array, mode: 'w')
    File.write(data_file_path, array.join(SEPERATOR) + "\n", mode: mode)
  end
end

puts CheoScraper.new.vasy
