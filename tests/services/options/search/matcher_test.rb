require 'minitest/autorun'
require_relative '../../../../services/options/search/matcher'

module Options
  module Search
    class MatcherTest < Minitest::Test
      def setup
        @raw_data = [
          {
            'id' => 123,
            'name' => 'John Doe'
          }
        ]
      end

      class WhenThereAreValidationErrors < MatcherTest
        def test_raise_validation_error_when_no_options_are_passed
          assert_raises Exceptions::ValidationError do
            Options::Search::Matcher.call(@raw_data, {})
          end
        end

        def test_raise_validation_error_when_invalid_field_is_passed
          options = { search_field: 'invalid_field', search_value: 123 }
          assert_raises Exceptions::ValidationError do
            Options::Search::Matcher.call(@raw_data, options)
          end
        end

        def test_raise_validation_error_when_no_search_value_is_passed
          options = { search_field: 'id' }
          assert_raises Exceptions::ValidationError do
            Options::Search::Matcher.call(@raw_data, options)
          end
        end

        def test_raise_validation_error_when_no_search_field_is_passed
          options = { search_value: 123 }
          assert_raises Exceptions::ValidationError do
            Options::Search::Matcher.call(@raw_data, options)
          end
        end
      end

      class WhenSearchFieldArePassed < MatcherTest
        def test_return_matching_objects
          options = { search_field: 'id', search_value: 123 }
          results = Options::Search::Matcher.call(@raw_data, options)

          assert_equal results, [{ 'id' => 123, 'name' => 'John Doe' }]
        end

        def test_return_matching_objects_with_case_insensitive_search
          options = { search_field: 'name', search_value: 'john' }
          results = Options::Search::Matcher.call(@raw_data, options)

          assert_equal results, [{ 'id' => 123, 'name' => 'John Doe' }]
        end

        def test_no_return_when_no_matching_object_found
          options = { search_field: 'id', search_value: 456 }
          results = Options::Search::Matcher.call(@raw_data, options)

          assert_empty results
        end
      end
    end
  end
end