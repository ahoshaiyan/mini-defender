# frozen_string_literal: true

require 'test_helper'

class NotLocalURLTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::NotLocalURL.new
  end

  def test_signature
    assert_equal 'not_local_url', MiniDefender::Rules::NotLocalURL.signature
  end

  def test_passes_with_regular_domains
    %w[https://example.com https://api.example.com https://subdomain.example.com https://my-domain.com].each do |url|
      assert @rule.passes?(:url, url, nil), "#{url} should pass"
    end
  end

  def test_fails_with_localhost_variations
    %w[https://localhost https://LOCALHOST https://localhost:3000 https://localhost.example].each do |url|
      refute @rule.passes?(:url, url, nil), "#{url} should fail"
    end
  end

  def test_fails_with_localhost_ips
    %w[https://127.0.0.1 https://127.0.0.1:3000 https://127.0.1.1 https://::1 https://0.0.0.0 https://::].each do |url|
      refute @rule.passes?(:url, url, nil), "#{url} should fail"
    end
  end

  def test_fails_with_local_domains
    %w[https://myapp.local https://test.LOCAL https://local.test https://LOCAL.example
       https://service.local].each do |url|
      refute @rule.passes?(:url, url, nil), "#{url} should fail"
    end
  end

  def test_error_message
    expected_message = 'URL cannot point to localhost or local domain.'
    assert_equal expected_message, @rule.message(:url, 'https://localhost', nil)
  end
end
