# frozen_string_literal: true

require 'test_helper'

class PasswordTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::Password.new
  end

  def test_valid_password
    password = "Password123!"
    assert @rule.passes?("password", password, nil)
    assert_equal "Password is valid.", @rule.message("password", password, nil)
  end

  def test_missing_lowercase
    password = "PASSWORD123!"
    refute @rule.passes?("password", password, nil)
    assert_equal "Password is missing: at least one lowercase letter.", @rule.message("password", password, nil)
  end

  def test_missing_uppercase
    password = "password123!"
    refute @rule.passes?("password", password, nil)
    assert_equal "Password is missing: at least one uppercase letter.", @rule.message("password", password, nil)
  end

  def test_missing_digit
    password = "Password!"
    refute @rule.passes?("password", password, nil)
    assert_equal "Password is missing: at least one digit.", @rule.message("password", password, nil)
  end

  def test_missing_special_character
    password = "Password123"
    refute @rule.passes?("password", password, nil)
    assert_equal "Password is missing: at least one special character.", @rule.message("password", password, nil)
  end

  def test_too_short
    password = "Pass1!"
    refute @rule.passes?("password", password, nil)
    assert_equal "Password is missing: at least 8 characters.", @rule.message("password", password, nil)
  end

  def test_multiple_missing_requirements
    password = "pass"
    refute @rule.passes?("password", password, nil)
    message = @rule.message("password", password, nil)
    assert_includes message, "at least 8 characters"
    assert_includes message, "at least one uppercase letter"
    assert_includes message, "at least one digit"
    assert_includes message, "at least one special character"
  end

  def test_non_string_input
    refute @rule.passes?("password", 12345, nil)
    assert_equal "Password must be a string.", @rule.message("password", 12345, nil)
  end

  def test_nil_input
    refute @rule.passes?("password", nil, nil)
    assert_equal "Password must be a string.", @rule.message("password", nil, nil)
  end

  def test_empty_string
    password = ""
    refute @rule.passes?("password", password, nil)
    message = @rule.message("password", password, nil)
    assert_includes message, "at least 8 characters"
    assert_includes message, "at least one lowercase letter"
    assert_includes message, "at least one uppercase letter"
    assert_includes message, "at least one digit"
    assert_includes message, "at least one special character"
  end
end
