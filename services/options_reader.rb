require 'optparse'

class OptionsReader
  attr_reader :filepath, :client_to_search, :find_duplicate_email

  def initialize
    OptionParser.new do |parser|
      parser.banner = "Usage: 'ruby app.rb [options]'"

      parser.on('-f', '--file FILEPATH', 'File path to read') do |filepath|
        @filepath = filepath
        Client.build_data(raw_data)
      end

      parser.on('-c', '--client NAME', 'Enter client name to search') do |name|
        @client_to_search = name
      end

      parser.on('-d', '--duplicate-email', 'Find duplicate emails') do
        @find_duplicate_email = true
      end
    end.parse!

    validate!
  end

  def print_raw_data
    puts "Reading file: #{filepath}"
    puts raw_data
  end

  private

  def validate!
    raise Exceptions::FilePathMissing, 'File path is required' unless filepath
  end

  def raw_data
    @raw_data ||= FilePathToRawDataAdapter.call(filepath)
  end
end