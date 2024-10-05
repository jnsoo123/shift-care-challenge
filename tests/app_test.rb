require 'minitest/autorun'
require_relative '../app'

class AppTest < Minitest::Test
  def test_no_errors_raised
    ARGV.replace(['-p', 'tests/fixtures/test_clients.json'])

    assert_output(/Reading file: tests\/fixtures\/test_clients.json/) { run_app }
  end

  def test_invalid_file_raised
    ARGV.replace(['-p', 'tests/fixtures/invalid_file.json'])

    assert_output(/File not found/) { run_app }
  end

  def test_missing_argument_raised
    ARGV.replace(['-p', 'tests/fixtures/test_clients.json', '-f'])

    assert_output(/missing argument: -f/) { run_app }
  end

  def test_validation_error_raised
    ARGV.replace(['-p', 'tests/fixtures/test_clients.json', '-f', 'invalid_field'])

    assert_output(/Field 'invalid_field' is invalid/) { run_app }
  end
end