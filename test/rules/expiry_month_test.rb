# frozen_string_literal: true

require 'test_helper'

class ExpiryMonthTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::ExpiryMonth.new
  end

  def test_accept_integer_value
    assert @rule.passes?('month', 1, nil)
  end

  def test_accept_string_digits
    assert @rule.passes?('month', '2', nil)
  end

  def test_accept_single_integer_value
    assert @rule.passes?('month', '3', nil)
  end

  def test_accept_string_with_leading_zero
    assert @rule.passes?('month', '04', nil)
  end

  def test_accept_one_to_twelve
    (1..12).each do |month|
      assert @rule.passes?('month', month.to_s.rjust(2, '0'), nil)
    end
  end

  def test_rejects_invalid_month
    refute @rule.passes?('month', '13', nil)
  end
end
