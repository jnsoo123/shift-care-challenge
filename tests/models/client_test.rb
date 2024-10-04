require 'minitest/autorun'
require_relative '../../init'

class TestClient < Minitest::Test
  def setup
    Client.reset_data
  end

  # #to_json
  def test_to_json
    client = ::Client.new(datum)

    expected_json = {
      id: 123,
      name: 'John Doe',
      email: 'john.doe@example.com'
    }.to_json
    assert_equal expected_json, client.to_json
  end

  # .build_data
  def test_self_build_data
    Client.build_data(data)

    assert_equal 2, ::Client.all.size
  end

  # .search

  def test_self_search_with_no_data
    Client.build_data([datum])

    assert_equal [], ::Client.search('Someone')
  end

  def test_self_search_with_one_datum
    Client.build_data([datum])

    assert_equal 123, ::Client.search('John').first.id
  end

  def test_self_search_with_two_data
    Client.build_data(data)
    assert_equal 2, ::Client.all.size

    clients = Client.search('j')
    assert_equal 123, clients.first.id
    assert_equal 456, clients.last.id
  end

  def test_self_search_with_lowercase
    Client.build_data([datum])
    assert_equal 1, ::Client.all.size

    clients = ::Client.search('doe')
    assert_equal 123, clients.first.id
    assert_equal 1, clients.size
  end

  def test_self_search_with_uppercase
    Client.build_data([datum])
    assert_equal 1, ::Client.all.size

    clients = ::Client.search('DOE')
    assert_equal 123, clients.first.id
    assert_equal 1, clients.size
  end

  # .find_duplicate_emails
  def test_self_find_duplicate_emails
    Client.build_data(data_with_duplicate_emails)
    assert_equal 2, ::Client.all.size

    clients = ::Client.find_duplicate_emails
    assert_equal 1, clients.keys.size
    assert_equal 'john.doe@example.com', clients.keys.first
    assert_equal 2, clients['john.doe@example.com'].size
  end

  def test_self_find_duplicate_emails_with_no_duplicates
    Client.build_data(data)
    assert_equal 2, ::Client.all.size

    clients = ::Client.find_duplicate_emails
    assert_equal({}, clients)
  end

  # .reset_data
  def test_self_reset_data
    Client.build_data(data)
    assert_equal 2, ::Client.all.size

    Client.reset_data
    assert_equal 0, ::Client.all.size
  end

  private

  def datum
    {
      'id' => 123,
      'full_name' => 'John Doe',
      'email' => 'john.doe@example.com'
    }
  end

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

  def data_with_duplicate_emails
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
