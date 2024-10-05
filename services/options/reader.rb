module Options
  class Reader
    attr_reader :filepath, :field_to_search, :search_term, :find_duplicate_email, :raw_data, :objects

    def initialize
      parse_options!
      @raw_data = ::FilePathToRawDataAdapter.call(filepath)
      build_objects
      validate!
    end

    private

    def validate!
      Validator.valid?(self)
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

    def build_objects
      @objects ||= raw_data.map { |data| OpenStruct.new(data) }
    end
  end
end