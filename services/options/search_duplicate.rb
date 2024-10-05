module Options
  class SearchDuplicate
    def self.call(reader)
      new(reader).perform
    end

    def initialize(reader)
      @objects = reader.objects
      @field   = reader.field_to_search_duplicate.to_sym
    end

    def perform
      @objects.group_by(&@field).select do |_, objects|
        objects.size > 1
      end
    end
  end
end