# require 'yaml'
require 'open-uri'
require 'uri'
require 'net/http'

class Download
  # @@config = YAML.load_file('config.yaml')
  @@base_url = "http://bgg.activityclub.org/olwlg/" 

  def start
    reset_output

    trade_id = 356412
    download "#{trade_id}-results-official.txt"
    download "#{trade_id}-officialwants.txt"
  end

  def reset_output
    Dir.mkdir 'tmp' unless File.exist?('tmp')
    Dir['tmp/*.xml'].each { |f| File.delete(f) }
  end

  def download(file)
    path = "#{@@base_url}#{file}"
    puts path
    text = URI.open(path, &:read)
    File.write("tmp/#{file}", text)
  end
end
