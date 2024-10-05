module Options
  module Search
    class Base
      def self.call(objects, options={})
        new(objects, options).perform
      end

      def initialize(_objects, _options); end;

      def perform
        validate!
        perform_search
      end

      private

      def validate!; end;

      def perform_search; end;

      def valid_field?
        valid_fields.include?(@field)
      end

      def valid_fields
        @objects.map(&:keys).flatten.uniq
      end

      def invalid_field_message
        "Field '#{@field}' is invalid. Valid fields are #{valid_fields.join(', ')}"
      end
    end
  end
end