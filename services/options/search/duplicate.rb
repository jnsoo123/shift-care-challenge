module Options
  module Search
    class Duplicate < Base
      def initialize(objects, options={})
        @objects = objects
        @field   = options[:search_field_duplicate]
      end

      private

      def perform_search
        @objects.group_by { |obj| obj[@field] }.select do |_, objects|
          objects.size > 1
        end
      end

      def validate!
        return unless @field

        raise Exceptions::ValidationError, "Field '#{@field}' is invalid" unless valid_field?
      end
    end
  end
end