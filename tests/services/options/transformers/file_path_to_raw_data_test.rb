require 'minitest/autorun'
require_relative '../../../../services/options/transformers/file_path_to_raw_data'

module Options
  module Transformers
    class FilePathToRawDataTest < Minitest::Test
      class WhenThereAreNoErrors < FilePathToRawDataTest
        def test_return_raw_data
          raw_data = Options::Transformers::FilePathToRawData.call('tests/fixtures/test_clients.json')

          assert_equal raw_data, [
            {
              'id' => 123,
              'full_name' => 'John Doe',
              'email' => 'john.doe@gmail.com'
            },
            {
              'id' => 456,
              'full_name' => 'Jane Smith',
              'email' => 'jane.smith@yahoo.com'
            }
          ]
        end
      end

      class WhenThereAreErrors < FilePathToRawDataTest
        def test_raise_error_when_file_is_not_found
          assert_raises Exceptions::InvalidFile do
            Options::Transformers::FilePathToRawData.call('tests/fixtures/non_existing_file.json')
          end
        end

        def test_raise_error_when_file_is_not_json
          assert_raises Exceptions::InvalidFile do
            Options::Transformers::FilePathToRawData.call('tests/fixtures/invalid_json_file.json')
          end
        end

        def test_raise_error_when_filepath_is_not_passed
          assert_raises Exceptions::InvalidFile do
            Options::Transformers::FilePathToRawData.call(nil)
          end
        end
      end
    end
  end
end
