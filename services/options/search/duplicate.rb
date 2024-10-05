module Options
  module Search
    class Duplicate < Base
      def initialize(objects, options={})
        @objects = objects
        @field   = options[:search_field_duplicate]
      end

      private

      def perform_search
        @objects.group_by { |obj| obj[@field] }.select do |value, objects|
          objects.size > 1 && !value.nil?
        end
      end

      def validate!
        return unless @field

        raise Exceptions::ValidationError, invalid_field_message unless valid_field?
      end
    end
  end
end