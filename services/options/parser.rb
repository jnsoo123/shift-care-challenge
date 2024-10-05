require 'optparse'

module Options
  class Parser
    attr_reader :filepath, :search_field, :search_value, :search_field_duplicate

    def initialize
      OptionParser.new do |parser|
        parser.banner = "Usage: 'ruby app.rb [options]'"

        parser.on('-p', '--path FILEPATH', 'File path to read') do |param|
          @filepath = param
        end

        parser.on('-f', '--find FIELD=VALUE', 'Specify field and value to search (e.g. --find name=John)') do |param|
          @search_field, @search_value = param.split('=')
        end

        parser.on('-d', '--find-duplicate FIELD', 'Find duplicate') do |param|
          @search_field_duplicate = param
        end
      end.parse!
    rescue OptionParser::MissingArgument => e
      raise Exceptions::MissingArgument, e.message
    end
  end
end