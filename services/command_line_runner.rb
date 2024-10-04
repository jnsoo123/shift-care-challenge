class CommandLineRunner
  def self.run(reader)
    new(reader).perform
  end

  def initialize(reader)
    @reader = reader
  end

  def perform
    # executed by default
    return @reader.print_raw_data unless @reader.client_to_search || @reader.find_duplicate_email

    if @reader.client_to_search
      search_clients
    end

    if @reader.find_duplicate_email
      find_duplicate_emails
    end
  end

  private

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

  def search_clients
    search_term = @reader.client_to_search

    puts "Searching for client: #{search_term}"
    puts '---------------------------------'

    clients = Client.search(search_term)

    if clients.empty?
      puts 'Client not found'

      return
    end

    puts "Number of clients found: #{clients.count}"
    puts '---------------------------------'
    clients.each { |client| puts client.to_json }
  end
end
