require 'minitest/autorun'
require_relative '../../init'

class TestOptionsReader < Minitest::Test
  # #print_raw_data
  def test_print_raw_data
    ARGV.replace(['-p', 'tests/fixtures/test_clients.json'])

    reader = OptionsReader.new
    assert_output(/Reading file: tests\/fixtures\/test_clients.json/) { reader.print_raw_data }
    assert_output(/{"id"=>123, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}/) { reader.print_raw_data }
    assert_output(/{"id"=>456, "full_name"=>"Jane Smith", "email"=>"jane.smith@yahoo.com"}/) { reader.print_raw_data }
  end

  def test_print_raw_data_with_no_filepath
    ARGV.replace([])

    assert_raises(Exceptions::FilePathMissing) { OptionsReader.new }
  end

  def teardown
    ARGV.clear
  end
end