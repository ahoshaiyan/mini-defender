# frozen_string_literal: true

require 'test_helper'

class PasswordTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::Hostname.new
  end

  def test_valid_hostname
    assert(@rule.passes?('hostname', 'www.example.com', nil))
  end

  def test_pass_for_trailing_dot
    assert(@rule.passes?('hostname', 'www.example.com.', nil))
  end

  def test_must_remove_trailing_dot
    assert(@rule.coerce('www.example.com'))
  end

  def test_fail_for_non_ascii
    refute(@rule.passes?('hostname', 'www.مثال.com', nil))
  end

  def test_allow_long_label
    label = '1' * 63
    assert(@rule.passes?('hostname', "#{label}.example.com", nil))
  end

  def test_allow_long_hostname
    label = '1' * 63
    assert(@rule.passes?('hostname', "#{label}.#{label}.#{label}.example.com", nil))
  end

  def single_char_subdomain_hostname
    assert(@rule.passes?('hostname', 'w.example.com', nil))
  end

  def test_must_fail_for_64_plus_label
    label = '1' * 64
    refute(@rule.passes?('hostname', "#{label}.example.com", nil))
  end

  def test_must_fail_for_254_plus_domain
    label = '1' * 63
    refute(@rule.passes?('hostname', "#{label}.#{label}.#{label}.#{label}.#{label}.example.com", nil))
  end
end
