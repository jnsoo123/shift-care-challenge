module Options
  class Validator
    def self.valid?(reader)
      new(reader).perform
    end

    def initialize(reader)
      @reader = reader
    end

    def perform
      validate_filepath!
      validate_search!
      validate_duplicate_field!
    end

    private

    def validate_filepath!
      return unless @reader.filepath

      raise Exceptions::FilePathMissing, 'File path is required' unless @reader.filepath
    end

    def validate_search!
      return unless @reader.field_to_search

      raise Exceptions::InvalidField, "Field '#{@reader.field_to_search}' is invalid" unless valid_field?(@reader.field_to_search)
    end

    def validate_duplicate_field!
      return unless @reader.field_to_search_duplicate

      raise Exceptions::InvalidField, "Field '#{@reader.field_to_search_duplicate}' is invalid" unless valid_field?(@reader.field_to_search_duplicate)
    end

    def valid_field?(field)
      fields = @reader.objects.first.to_h.keys
      fields.include?(field.to_sym)
    end
  end
end