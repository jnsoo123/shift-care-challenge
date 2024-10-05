class CommandLineRunner
  def self.run(reader)
    new(reader).perform
  end

  def initialize(reader)
    @reader = reader
  end

  def perform
    # executed by default
    return print_raw_data if execute_default?

    if @reader.field_to_search && @reader.search_term
      search_objects
    end

    if @reader.field_to_search_duplicate
      find_duplicate_emails
    end
  end

  private

  def execute_default?
    @reader.field_to_search.nil? &&
      @reader.search_term.nil? &&
      @reader.field_to_search_duplicate.nil?
  end

  def print_raw_data
    puts "Reading file: #{@reader.filepath}"
    puts @reader.raw_data
  end

  def find_duplicate_emails
    duplicates = Options::SearchDuplicate.call(@reader)


    if duplicates.empty?
      puts "No duplicate #{@reader.field_to_search_duplicate} found"

      return
    end

    duplicates.each do |value, objects|
      puts "Duplicate #{@reader.field_to_search_duplicate}='#{value}' found:"
      objects.each { |object| puts object.to_h.to_json }
      puts '---------------------------------'
    end
  end

  def search_objects
    objects = Options::Search.call(@reader)

    if objects.empty?
      puts 'Object not found'

      return
    end

    puts "Searching for #{@reader.field_to_search}: #{@reader.search_term}"
    puts "Number of objects found: #{objects.count}"
    puts '---------------------------------'
    objects.each { |object| puts object.to_h.to_json }
    puts '---------------------------------'
  end
end
