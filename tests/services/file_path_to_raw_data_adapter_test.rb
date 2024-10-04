require 'minitest/autorun'
require_relative '../../init'

class TestFilePathToRawDataAdapter < Minitest::Test
  def test_self_call
    filepath = 'tests/fixtures/test_clients.json'
    raw_data = FilePathToRawDataAdapter.call(filepath)

    assert_equal 2, raw_data.size
    assert_equal 123, raw_data.first['id']
    assert_equal 456, raw_data.last['id']
  end

  def test_self_call_with_non_existing_file
    filepath = 'tests/fixtures/non_existing.json'

    assert_raises(Exceptions::InvalidFile) do
      FilePathToRawDataAdapter.call(filepath)
    end
  end

  def test_self_call_with_invalid_file
    filepath = 'tests/fixtures/invalid_json_file.json'

    assert_raises(Exceptions::InvalidFile) do
      FilePathToRawDataAdapter.call(filepath)
    end
  end
end
