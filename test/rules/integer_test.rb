# frozen_string_literal: true

require 'test_helper'

class IntegerTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::Integer.new
    @rule_relax = MiniDefender::Rules::Integer.new('relaxed')
  end

  def test_passes_with_string_positive_integer
    assert(@rule.passes?("test", "10", nil))
  end

  def test_passes_with_string_negative_integer
    assert(@rule.passes?("test", "-10", nil))
  end

  def test_fails_with_float
    refute(@rule.passes?("test", 10.5, nil))
  end

  def test_fails_with_string_float
    refute(@rule.passes?("test", "10.5", nil))
  end

  def test_fails_with_non_numeric_string
    refute(@rule.passes?("test", "not a number", nil))
  end

  def test_fails_with_nil
    refute(@rule.passes?("test", nil, nil))
  end

  def test_fails_with_array
    refute(@rule.passes?("test", [], nil))
  end

  def test_fails_with_hash
    refute(@rule.passes?("test", {}, nil))
  end

  def test_passes_with_integer
    assert @rule.passes?('amount', 1, nil)
    assert_equal 1, @rule.coerce(1)
  end

  def test_strict_fails_with_arabic_digits
    refute @rule.passes?('amount', '٣', nil)
  end

  def test_relaxed_passes_with_arabic_digits
    assert @rule_relax.passes?('amount', '٣', nil)
    assert_equal 3, @rule_relax.coerce('٣')
  end

  def test_relaxed_passes_with_mixed_digits
    assert @rule_relax.passes?('amount', '2٣', nil)
    assert_equal 23, @rule_relax.coerce('2٣')
  end

  def test_passes_with_integer_with_leading_zero
    assert @rule_relax.passes?('amount', '08', nil)
  end

  def test_passes_with_single_zero
    assert @rule.passes?('amount', '0', nil)
    assert_equal 0, @rule.coerce('0')
  end

  def test_passes_with_multiple_zeros
    assert @rule.passes?('amount', '00', nil)
    assert_equal 0, @rule.coerce('00')
  end

  # Test for leading zeros before other digits
  def test_removes_leading_zeros_before_digits
    assert @rule.passes?('amount', '01', nil)
    assert_equal 1, @rule.coerce('01')

    assert @rule.passes?('amount', '0123', nil)
    assert_equal 123, @rule.coerce('0123')

    assert @rule.passes?('amount', '00123', nil)
    assert_equal 123, @rule.coerce('00123')
  end

  def test_handles_zeros_with_whitespace
    assert @rule.passes?('amount', ' 0 ', nil)
    assert_equal 0, @rule.coerce(' 0 ')

    assert @rule.passes?('amount', ' 00 ', nil)
    assert_equal 0, @rule.coerce(' 00 ')
  end

  def test_handles_negative_numbers_with_leading_zeros
    assert @rule.passes?('amount', '-001', nil)
    assert_equal(-1, @rule.coerce('-001'))

    assert @rule.passes?('amount', '-00123', nil)
    assert_equal(-123, @rule.coerce('-00123'))
  end

  def test_handles_positve_numbers_with_leading_zeros
    assert @rule.passes?('amount', '+001', nil)
    assert_equal(1, @rule.coerce('+001'))

    assert @rule.passes?('amount', '+00123', nil)
    assert_equal(123, @rule.coerce('+00123'))
  end
end
