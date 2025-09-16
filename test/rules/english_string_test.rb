# frozen_string_literal: true

require 'test_helper'

class EnglishStringTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::EnglishString.new
  end

  def test_valid_english_string_with_spaces
    assert(@rule.passes?('Name', 'Abdullah Ali', true))
  end

  def test_valid_english_string_without_spaces
    assert(@rule.passes?('Name', 'Abdullah', true))
  end

  def test_coerce_removing_spaces_from_empty_string
    assert_equal(@rule.coerce('   '),'')
  end

  def test_coerce_removing_spaces_from_non_empty_string
    assert_equal(@rule.coerce(' Abdullah Ali '),'Abdullah Ali')
  end
  def test_must_fail_for_numbers_only_as_string
    refute(@rule.passes?('Name', "111", true))
  end
  def test_must_fail_for_value_not_string
    refute(@rule.passes?('Name', 111, true))
    refute(@rule.passes?('Name', true, true))
    refute(@rule.passes?('Name', ['string'], true))
  end
  def test_must_fail_for_empty_string
    refute(@rule.passes?('Name', "", true))
  end

  def test_must_fail_for_numbers_with_characters
    refute(@rule.passes?('Name', "111Abdullah", true))
    refute(@rule.passes?('Name', "Abdullah111", true))
    refute(@rule.passes?('Name', "111Abdullah111", true))
  end

  def test_must_fail_for_string_with_special_characters
    refute(@rule.passes?('Name', "Abdullah.Mohammed", true))
    refute(@rule.passes?('Name', "Abdullah@Mohammed", true))
    refute(@rule.passes?('Name', "$AbdullahMohammed", true))
    refute(@rule.passes?('Name', "$Abdullah.Mohammed@", true))
  end
end
