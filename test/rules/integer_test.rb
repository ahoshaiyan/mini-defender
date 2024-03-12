# frozen_string_literal: true

require 'test_helper'

class IntegerTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::Integer.new
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
end
