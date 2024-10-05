class AppRunner
  def self.run(parser, raw_data)
    new(parser, raw_data).perform
  end

  def initialize(parser, raw_data)
    @parser   = parser
    @filepath = parser.filepath
    @raw_data = raw_data

    @search_field           = parser.search_field
    @search_value           = parser.search_value
    @search_field_duplicate = parser.search_field_duplicate
  end

  def perform
    # executed by default
    return print_raw_data if execute_default?

    if @search_field || @search_value
      search_objects
    end

    if @search_field_duplicate
      find_duplicates
    end
  end

  private

  def execute_default?
    @search_field.nil? &&
      @search_value.nil? &&
      @search_field_duplicate.nil?
  end

  def print_raw_data
    puts "Reading file: #{@filepath}"
    @raw_data.each { |datum| puts datum }
  end

  def search_objects
    options = { search_field: @search_field, search_value: @search_value }
    results = Options::Search::Matcher.call(@raw_data, options)

    if results.empty?
      puts 'Object not found'

      return
    end

    puts "Searching for #{@search_field}: #{@search_value}"
    puts "Number of objects found: #{results.count}"
    puts '---------------------------------'
    results.each { |result| puts result }
    puts '---------------------------------'
  end

  def find_duplicates
    options = { search_field_duplicate: @search_field_duplicate }
    results = Options::Search::Duplicate.call(@raw_data, options)

    if results.empty?
      puts "No duplicate #{@search_field_duplicate} found"

      return
    end

    results.each do |value, raw_data|
      puts "Duplicate #{@search_field_duplicate}='#{value}' found:"
      raw_data.each { |datum| puts datum }
      puts '---------------------------------'
    end
  end
end
