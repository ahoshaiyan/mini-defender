# frozen_string_literal: true

require 'test_helper'

class NumericTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::Numeric.new
  end

  def test_passes_with_integer
    assert @rule.passes?(nil, 25, true)
  end

  def test_passes_with_float
    assert @rule.passes?(nil, 19.99, true)
  end

  def test_passes_with_zero
    assert @rule.passes?(nil, 0, true)
  end

  def test_passes_with_negative_number
    assert @rule.passes?(nil, -10, true)
  end

  def test_passes_with_numeric_string
    assert @rule.passes?(nil, "42", true)
  end

  def test_passes_with_float_string
    assert @rule.passes?(nil, "72.5", true)
  end

  def test_passes_with_string_with_commas
    assert @rule.passes?(nil, "50,000", true)
  end

  def test_fails_with_non_numeric_string
    refute @rule.passes?(nil, "John", true)
  end

  def test_fails_with_empty_string
    refute @rule.passes?(nil, "", true)
  end

  def test_fails_with_nil
    refute @rule.passes?(nil, nil, true)
  end

  def test_fails_with_boolean
    refute @rule.passes?(nil, true, true)
  end

  def test_fails_with_array
    refute @rule.passes?(nil, [1, 2, 3], true)
  end

  def test_fails_with_hash
    refute @rule.passes?(nil, { key: "value" }, true)
  end

  def test_coerce_with_integer
    assert_equal 42, @rule.coerce(42)
  end

  def test_coerce_with_float
    assert_equal 3.14, @rule.coerce(3.14)
  end

  def test_coerce_with_numeric_string
    assert_equal 42.0, @rule.coerce("42")
  end

  def test_coerce_with_string_with_commas
    assert_equal 1000.0, @rule.coerce("1,000")
  end

  def test_coerce_raises_error_with_non_numeric_string
    assert_raises(ArgumentError) { @rule.coerce("abc") }
  end

  def test_message
    assert_equal "The field must contain a numeric value.", @rule.message(nil, "abc", true)
  end
end
