require 'optparse'

class OptionsReader
  attr_reader :filepath, :field_to_search, :search_term, :find_duplicate_email

  def initialize
    parse_options!
    validate!
  end

  def print_raw_data
    puts "Reading file: #{filepath}"
    puts raw_data
  end

  def raw_data
    @raw_data ||= FilePathToRawDataAdapter.call(filepath)
  end

  private

  def validate!
    raise Exceptions::FilePathMissing, 'File path is required' unless filepath
  end

  def parse_options!
    OptionParser.new do |parser|
      parser.banner = "Usage: 'ruby app.rb [options]'"

      parser.on('-p', '--path FILEPATH', 'File path to read') do |filepath|
        @filepath = filepath
      end

      parser.on('-f', '--find FIELD=VALUE', 'Specify field and value to search (e.g. --find name=John') do |param|
        @field_to_search, @search_term = param.split('=')
      end

      parser.on('-d', '--duplicate-email', 'Find duplicate emails') do
        @find_duplicate_email = true
      end
    end.parse!
  rescue OptionParser::MissingArgument => _e
    raise Exceptions::MissingArgument, 'File path is required'
  end
end