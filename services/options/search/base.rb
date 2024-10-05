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
    end
  end
end