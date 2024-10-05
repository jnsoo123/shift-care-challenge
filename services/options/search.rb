module Options
  class Search
    def self.call(reader)
      new(reader).perform
    end

    def initialize(reader)
      @objects     = reader.objects
      @search_term = reader.search_term
      @field       = reader.field_to_search
    end

    def perform
      @objects.select { |object| object.send(@field) =~ Regexp.new(@search_term, Regexp::IGNORECASE) }
    end
  end
end