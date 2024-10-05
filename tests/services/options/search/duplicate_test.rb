require 'minitest/autorun'
require_relative '../../../../services/options/search/duplicate'

module Options
  module Search
    class DuplicateTest < Minitest::Test
      def setup
        @raw_data = [
          {
            'id' => 123,
            'name' => 'John Doe'
          },
          {
            'id' => 456,
            'name' => 'John Doe'
          }
        ]

        @raw_data_with_null_values = [
          {
            'id' => 123,
            'name' => nil
          },
          {
            'id' => 456,
            'name' => nil
          }
        ]
      end

      class WhenThereAreValidationErrors < DuplicateTest
        def test_raise_validation_error_when_no_options_are_passed
          options = { search_field_duplicate: '' }
          assert_raises Exceptions::ValidationError do
            Options::Search::Duplicate.call(@raw_data, options)
          end
        end

        def test_raise_validation_error_when_invalid_field_is_passed
          options = { search_field_duplicate: 'invalid_field' }
          assert_raises Exceptions::ValidationError do
            Options::Search::Duplicate.call(@raw_data, options)
          end
        end
      end

      class WhenThereAreNoValidationErrors < DuplicateTest
        def test_return_matching_objects
          options = { search_field_duplicate: 'name' }
          results = Options::Search::Duplicate.call(@raw_data, options)

          expected_result = {
            'John Doe' => [
              { 'id' => 123, 'name' => 'John Doe' },
              { 'id' => 456, 'name' => 'John Doe' }
            ]
          }

          assert_equal results, expected_result
        end

        def test_return_nothing_when_no_duplicates_found
          options = { search_field_duplicate: 'id' }
          results = Options::Search::Duplicate.call(@raw_data, options)

          assert_empty results
        end

        def test_return_nothing_when_field_value_is_nil
          options = { search_field_duplicate: 'name' }
          results = Options::Search::Duplicate.call(@raw_data_with_null_values, options)

          assert_empty results
        end
      end
    end
  end
end
