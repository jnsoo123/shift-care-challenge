class CommandLineRunner
  def self.run(reader, raw_data)
    new(reader, raw_data).perform
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

    if @search_field && @search_value
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
    @objects.each { |object| puts object.to_h.to_json }
  end

  def search_objects
    options = { search_field: @search_field, search_value: @search_value }
    objects = Options::Search::Matcher.call(@raw_data, options)

    if objects.empty?
      puts 'Object not found'

      return
    end

    puts "Searching for #{@search_field}: #{@search_value}"
    puts "Number of objects found: #{objects.count}"
    puts '---------------------------------'
    objects.each { |object| puts object.to_h.to_json }
    puts '---------------------------------'
  end

  def find_duplicates
    options = { search_field_duplicate: @search_field_duplicate }
    duplicates = Options::Search::Duplicate.call(@raw_data, options)


    if duplicates.empty?
      puts "No duplicate #{@search_field_duplicate} found"

      return
    end

    duplicates.each do |value, objects|
      puts "Duplicate #{@search_field_duplicate}='#{value}' found:"
      objects.each { |object| puts object.to_h.to_json }
      puts '---------------------------------'
    end
  end
end
