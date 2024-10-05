module Options
  class Reader
    attr_reader :filepath, :field_to_search, :search_term, :field_to_search_duplicate, :raw_data, :objects

    def initialize
      parse_options!

      @raw_data = build_raw_data
      @objects = build_objects

      validate!
    end

    private

    def validate!
      Validator.valid?(self)
    end

    def parse_options!
      OptionParser.new do |parser|
        parser.banner = "Usage: 'ruby app.rb [options]'"

        parser.on('-p', '--path FILEPATH', 'File path to read') do |param|
          @filepath = param
        end

        parser.on('-f', '--find FIELD=VALUE', 'Specify field and value to search (e.g. --find name=John') do |param|
          @field_to_search, @search_term = param.split('=')
        end

        parser.on('-d', '--find-duplicate FIELD', 'Find duplicate') do |param|
          @field_to_search_duplicate = param
        end
      end.parse!
    rescue OptionParser::MissingArgument => e
      raise Exceptions::MissingArgument, e.message
    end

    def build_objects
      raw_data.map { |data| OpenStruct.new(data) }
    end

    def build_raw_data
      ::FilePathToRawDataAdapter.call(filepath)
    end
  end
end