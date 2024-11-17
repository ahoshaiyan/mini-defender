# frozen_string_literal: true

require 'test_helper'

class UrlTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::Url
  end

  def test_basic_url_validation
    validator = @rule.new

    assert validator.passes?(nil, 'https://github.com', nil)
    assert validator.passes?(nil, 'http://github.com', nil)

    refute validator.passes?(nil, 'not_a_url', nil)
    refute validator.passes?(nil, nil, nil)
    refute validator.passes?(nil, 123, nil)
    refute validator.passes?(nil, '', nil)
  end

  def test_https_modifier
    validator = @rule.new(['https'])

    assert validator.passes?(nil, 'https://github.com', nil)
    assert validator.passes?(nil, 'https://example.com', nil)

    refute validator.passes?(nil, 'http://github.com', nil)
    assert_equal 'The URL must use HTTPS.', validator.message(nil, nil, nil)
  end

  def test_public_modifier
    validator = @rule.new(['public'])

    assert validator.passes?(nil, 'https://github.com', nil)
    assert validator.passes?(nil, 'http://google.com', nil)

    refute validator.passes?(nil, 'http://example.com', nil)
    refute validator.passes?(nil, 'http://localhost', nil)
    refute validator.passes?(nil, 'http://site.example', nil)
    refute validator.passes?(nil, 'http://demo.example', nil)
    refute validator.passes?(nil, 'http://test.example', nil)
    refute validator.passes?(nil, 'http://staging', nil)

    assert_equal 'The URL must use a valid public domain.', validator.message(nil, nil, nil)
  end

  def test_not_ip_modifier
    validator = @rule.new(['not_ip'])

    assert validator.passes?(nil, 'http://github.com', nil)
    assert validator.passes?(nil, 'http://localhost', nil)

    refute validator.passes?(nil, 'http://192.168.1.1', nil)
    refute validator.passes?(nil, 'http://8.8.8.8', nil)
    refute validator.passes?(nil, 'http://[::1]', nil)
    assert_equal 'IP addresses are not allowed in URLs.', validator.message(nil, nil, nil)
  end

  def test_not_private_modifier
    validator = @rule.new(['not_private'])

    assert validator.passes?(nil, 'http://github.com', nil)

    refute validator.passes?(nil, 'http://localhost', nil)
    refute validator.passes?(nil, 'http://192.168.1.1', nil)
    refute validator.passes?(nil, 'http://127.0.0.1', nil)
    refute validator.passes?(nil, 'http://test.local', nil)
    assert_equal 'Private or reserved resources are not allowed.', validator.message(nil, nil, nil)
  end

  def test_combined_modifiers
    validator = @rule.new(%w[https public])

    assert validator.passes?(nil, 'https://github.com', nil)

    refute validator.passes?(nil, 'http://github.com', nil)
    refute validator.passes?(nil, 'https://localhost', nil)
    refute validator.passes?(nil, 'https://192.168.1.1', nil)
  end

  def test_edge_cases
    validator = @rule.new(%w[https public not_ip])

    # Malformed URLs
    refute validator.passes?(nil, 'https://', nil)
    refute validator.passes?(nil, 'https:///', nil)
    refute validator.passes?(nil, 'https:', nil)

    # Special chars
    refute validator.passes?(nil, 'https://site with spaces.com', nil)
    assert validator.passes?(nil, 'https://site-with-dashes.com', nil)
    assert validator.passes?(nil, 'https://subdomain.domain.com', nil)

    # Port numbers
    assert validator.passes?(nil, 'https://github.com:443', nil)
    assert validator.passes?(nil, 'https://site.com:8080', nil)

    # Query parameters and fragments
    assert validator.passes?(nil, 'https://github.com?param=value', nil)
    assert validator.passes?(nil, 'https://github.com#section', nil)
  end

  def test_idn_handling
    validator = @rule.new(['public'])
    # TODO: Shall Punycode forms be blocked?
    # Punycode form (encoded form of Chinese--ready to buy)
    assert validator.passes?(nil, 'https://xn--6qq79v.com', nil)
  end

  def test_invalid_modifiers
    error = assert_raises(ArgumentError) do
      @rule.new(['invalid_modifier'])
    end

    assert_match(/Invalid URL modifiers/, error.message)
  end

  def test_private_network_detection
    assert @rule.new.private_network?('localhost')
    assert @rule.new.private_network?('127.0.0.1')
    assert @rule.new.private_network?('192.168.1.1')
    assert @rule.new.private_network?('10.0.0.1')
    assert @rule.new.private_network?('test.local')

    refute @rule.new.private_network?('github.com')
    refute @rule.new.private_network?('8.8.8.8')
  end

  def test_must_return_default_message_when_value_is_not_a_url
    validator = @rule.new(['https'])

    refute validator.passes?(nil, 'not_a_url', nil)

    assert_equal(
      'The field must contain a valid URL.',
      validator.message(nil, nil, nil)
    )
  end

  def test_validator_returns_an_error_message_for_https_modifier_error
    validator = @rule.new(['https'])

    refute validator.passes?(nil, 'http://github.com', nil)

    assert_equal(
      'The URL must use HTTPS.',
      validator.message(nil, nil, nil)
    )
  end
end
