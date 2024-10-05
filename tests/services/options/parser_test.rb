require 'minitest/autorun'
require_relative '../../../services/options/parser'

module Options
  class ParserTest < Minitest::Test
    def test_parses_file_path_when_file_is_passed
      ARGV.replace(['-p', 'filename.json'])

      parser = Options::Parser.new

      assert_equal parser.filepath, 'filename.json'
    end

    def test_parses_search_field_and_search_value_when_find_is_passed
      ARGV.replace(['-f', 'name=John'])

      parser = Options::Parser.new

      assert_equal parser.search_field, 'name'
      assert_equal parser.search_value, 'John'
    end

    def test_parses_search_field_duplicate_when_find_duplicate_is_passed
      ARGV.replace(['-d', 'name'])

      parser = Options::Parser.new

      assert_equal parser.search_field_duplicate, 'name'
    end

    class WhenNoArgumentsArePassed < ParserTest
      def test_raises_missing_argument_error_when_no_args_are_passed_for_path
        ARGV.replace(['-p'])

        assert_raises Exceptions::MissingArgument do
          Options::Parser.new
        end
      end

      def test_raises_missing_argument_error_when_no_args_are_passed_for_find
        ARGV.replace(['-f'])

        assert_raises Exceptions::MissingArgument do
          Options::Parser.new
        end
      end


      def test_raises_missing_argument_error_when_no_args_are_passed_for_find_duplicate
        ARGV.replace(['-d'])

        assert_raises Exceptions::MissingArgument do
          Options::Parser.new
        end
      end
    end

    def teardown
      ARGV.clear
    end
  end
end
