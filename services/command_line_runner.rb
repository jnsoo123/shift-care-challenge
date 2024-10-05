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

    if @reader.find_duplicate_email
      find_duplicate_emails
    end
  end

  private

  def execute_default?
    @reader.field_to_search.nil? && @reader.search_term.nil? && @reader.find_duplicate_email.nil?
  end

  def print_raw_data
    puts "Reading file: #{@reader.filepath}"
    puts @reader.raw_data
  end

  def find_duplicate_emails
    duplicates = Client.find_duplicate_emails

    if duplicates.empty?
      puts 'No duplicate emails found'

      return
    end

    puts 'Duplicate emails found:'
    duplicates.each do |email, clients|
      puts "Email: #{email}"
      clients.each { |client| puts client.to_json }
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
