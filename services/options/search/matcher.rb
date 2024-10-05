module Options
  module Search
    class Matcher < Base
      def initialize(objects, options={})
        @objects = objects
        @value   = options[:search_value]
        @field   = options[:search_field]
      end

      private

      def perform_search
        @objects.select do |object|
          object[@field].to_s =~ Regexp.new(@value.to_s, Regexp::IGNORECASE)
        end
      end

      def validate!
        raise Exceptions::ValidationError, invalid_field_message unless valid_field?
        raise Exceptions::ValidationError, "Search term is required (e.g. -f #{@field}=search_term)" unless @value
      end
    end
  end
end