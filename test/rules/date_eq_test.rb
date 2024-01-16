# frozen_string_literal: true

require 'test_helper'

class DateEqTest < Minitest::Test
  def setup
    @validator = MiniDefender::Validator.new([], [])
    @rule = MiniDefender::Rules::DateEq.new('2022-09-10')
  end

  def test_must_panic_when_invalid_target_date_is_given
    assert_raises ArgumentError do
      MiniDefender::Rules::DateEq.new('invalid date iz dis؟')
    end
  end

  def test_must_fails_when_an_invalid_date_is_given
    assert !@rule.passes?('date_attribute', 'helo? dis det?', @validator)
  end

  def test_message_for_invalid_date_must_reflect_the_case
    assert !@rule.passes?('date_attribute', 'helo? dis det?', @validator)
    assert_equal 'The given value is not a valid date.', @rule.message('date_attribute', 'helo? dis det?', @validator)
  end

  def test_must_fails_when_not_equal_date_is_given
    assert !@rule.passes?('date_attribute', '2022-09-11', @validator)
    assert !@rule.passes?('date_attribute', '2022-09-09', @validator)
  end

  def test_not_equal_date_message_reflects_the_case
    assert !@rule.passes?('date_attribute', '2022-09-11', @validator)
    assert_equal(
      "The value must be equal to #{Time.parse('2022-09-10')}.",
      @rule.message('date_attribute', '2022-09-11', @validator)
    )
  end
end
