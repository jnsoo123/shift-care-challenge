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

    puts "Duplicate #{@reader.field_to_search_duplicate} found:"
    duplicates.each do |field, objects|
      puts "Field: #{field}"
      objects.each { |object| puts object.to_json }
      puts '---------------------------------'
    end
  end

  def search_objects
    puts "Searching for object: #{@reader.search_term}"
    puts '---------------------------------'

    objects = Options::Search.call(@reader)

    if objects.empty?
      puts 'Object not found'

      return
    end

    puts "Number of objects found: #{objects.count}"
    puts '---------------------------------'
    objects.each { |object| puts object.to_h.to_json }
  end
end
