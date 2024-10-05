class Client

  class << self
    attr_reader :all

    def build_data(raw_data)
      @all ||= []

      raw_data.each do |data|
        @all << Client.new(data)
      end
    end

    def search(field, search_term)
      return [] if all.nil?

      field = field.downcase

      all.select do |client|
        client.send(field) =~ Regexp.new(search_term, Regexp::IGNORECASE)
      end
    end

    def find_duplicate_emails
      all.group_by(&:email).select { |_, clients| clients.size > 1 }
    end

    def reset_data
      @all = []
    end
  end

  attr_reader :id, :full_name, :email

  def initialize(data)
    @id        = data['id']
    @full_name = data['full_name']
    @email     = data['email']
  end

  def to_json
    {
      id: id,
      full_name: full_name,
      email: email
    }.to_json
  end
end