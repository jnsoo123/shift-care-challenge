require 'minitest/autorun'
require_relative '../../services/app_runner'

class AppRunnerTest < Minitest::Test
  def setup
    @raw_data = [
      { 'id' => 123, 'name' => 'John Doe' },
      { 'id' => 456, 'name' => 'Jane Smith' }
    ]
  end

  def mocked_parser_with_blank_search_fields
    parser = Minitest::Mock.new

    parser.expect :filepath, 'clients.json'
    parser.expect :search_field, nil
    parser.expect :search_value, nil
    parser.expect :search_field_duplicate, nil

    parser
  end

  def mocked_parser_with_search_field_and_search_value
    parser = Minitest::Mock.new

    parser.expect :filepath, 'clients.json'
    parser.expect :search_field,'id'
    parser.expect :search_value, 123
    parser.expect :search_field_duplicate, nil

    parser
  end

  def mocked_parser_with_search_field_duplicate
    parser = Minitest::Mock.new

    parser.expect :filepath, 'clients.json'
    parser.expect :search_field,nil
    parser.expect :search_value, nil
    parser.expect :search_field_duplicate, 'id'

    parser
  end

  class WhenOnlyFileIsPassed < AppRunnerTest
    def test_prints_all_data
      parser = mocked_parser_with_blank_search_fields
      assert_output(/Reading file: clients.json.*"id"=>123, "name"=>"John Doe".*"id"=>456, "name"=>"Jane Smith"/m) do
        AppRunner.run(parser, @raw_data)
      end
    end
  end

  class WhenSearchFieldsArePassed < AppRunnerTest
    def test_prints_object_not_found_when_no_results
      matcher = Minitest::Mock.new
      options = { search_field: 'id', search_value: 123 }
      matcher.expect(:call, [], [@raw_data, options])

      Options::Search::Matcher.stub(:call, matcher) do
        parser = mocked_parser_with_search_field_and_search_value
        assert_output(/Object not found/) { AppRunner.run(parser, @raw_data) }
      end

      matcher.verify
    end
    def test_prints_correct_output_when_there_are_results
      matcher = Minitest::Mock.new
      options = { search_field: 'id', search_value: 123 }
      matcher.expect(:call, [{ 'id' => 123, 'name' => 'John Doe' }], [@raw_data, options])

      Options::Search::Matcher.stub(:call, matcher) do
        assert_output(/Searching for id: 123.*Number of objects found: 1.*"id"=>123, "name"=>"John Doe"/m) do
          parser = mocked_parser_with_search_field_and_search_value
          AppRunner.run(parser, @raw_data)
        end
      end

      matcher.verify
    end
  end

  class WhenSearchFieldDuplicateIsPassed < AppRunnerTest
    def test_prints_no_duplicate_when_no_results
      duplicate = Minitest::Mock.new
      options = { search_field_duplicate: 'id' }
      duplicate.expect(:call, [], [@raw_data, options])

      Options::Search::Duplicate.stub(:call, duplicate) do
        parser = mocked_parser_with_search_field_duplicate
        assert_output(/No duplicate id found/) do
          AppRunner.run(parser, @raw_data)
        end
      end
    end

    def test_print_correct_output_when_there_are_results
      duplicate = Minitest::Mock.new
      options = { search_field_duplicate: 'id' }
      mocked_result = {
        123 => [
          { 'id' => 123, 'name' => 'John Doe' },
          { 'id' => 123, 'name' => 'John Doe' }
        ]
      }
      duplicate.expect(:call, mocked_result, [@raw_data, options])

      Options::Search::Duplicate.stub(:call, duplicate) do
        assert_output(/"id"=>123, "name"=>"John Doe".*"id"=>123, "name"=>"John Doe/m) do
          parser = mocked_parser_with_search_field_duplicate
          AppRunner.run(parser, @raw_data)
        end
      end
    end
  end
end