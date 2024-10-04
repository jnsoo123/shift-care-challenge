class Client

  class << self
    attr_reader :all

    def build_data(raw_data)
      @all ||= []

      raw_data.each do |data|
        @all << Client.new(data)
      end
    end

    def search(search_term)
      all.select do |client|
        client.name =~ Regexp.new(search_term, Regexp::IGNORECASE)
      end
    end

    def find_duplicate_emails
      all.group_by(&:email).select { |_, clients| clients.size > 1 }
    end
  end

  attr_reader :id, :name, :email

  def initialize(data)
    @id    = data['id']
    @name  = data['full_name']
    @email = data['email']
  end

  def to_json
    {
      id: id,
      name: name,
      email: email
    }.to_json
  end
end