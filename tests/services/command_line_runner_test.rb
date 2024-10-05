require 'minitest/autorun'
require_relative '../../init'

class TestCommandLineRunner < Minitest::Test
  def setup
    Client.reset_data
  end

  # #run
  def test_run_with_default_output
    ARGV.replace(['-p', 'tests/fixtures/test_clients.json'])

    reader = OptionsReader.new
    assert_output(/Reading file: tests\/fixtures\/test_clients.json/) { reader.print_raw_data }
    assert_output(/{"id"=>123, "full_name"=>"John Doe", "email"=>"john.doe@gmail.com"}/) { reader.print_raw_data }
    assert_output(/{"id"=>456, "full_name"=>"Jane Smith", "email"=>"jane.smith@yahoo.com"}/) { reader.print_raw_data }
  end

  def test_run_with_client_to_search
    Client.build_data(data)

    ARGV.replace(['-p', 'tests/fixtures/test_clients.json', '-f', 'full_name=John'])

    reader = OptionsReader.new
    assert_output(/Searching for client: John/) { CommandLineRunner.run(reader) }
    assert_output(/Number of clients found: 1/) { CommandLineRunner.run(reader) }
  end

  def test_run_with_client_to_search_with_no_data
    Client.build_data(data)

    ARGV.replace(['-p', 'tests/fixtures/test_clients.json', '-f', 'full_name=Someone'])

    reader = OptionsReader.new
    assert_output(/Searching for client: Someone/) { CommandLineRunner.run(reader) }
    assert_output(/Client not found/) { CommandLineRunner.run(reader) }
  end

  def test_run_with_find_duplicate_email
    Client.build_data(data_with_duplicate_email)

    ARGV.replace(['-p', 'tests/fixtures/test_clients.json', '-d'])

    reader = OptionsReader.new
    assert_output(/Duplicate emails found:/) { CommandLineRunner.run(reader) }
    assert_output(/Email: john.doe@example.com/) { CommandLineRunner.run(reader) }
  end

  private

  def data
    [
      {
        'id' => 123,
        'full_name' => 'John Doe',
        'email' => 'john.doe@example.com'
      },
      {
        'id' => 456,
        'full_name' => 'Jane Smith',
        'email' => 'jane.smith@example.com'
      }
    ]
  end

  def data_with_duplicate_email
    [
      {
        'id' => 123,
        'full_name' => 'John Doe',
        'email' => 'john.doe@example.com'
      },
      {
        'id' => 456,
        'full_name' => 'John Doe Jr.',
        'email' => 'john.doe@example.com'
      }
    ]
  end
end
