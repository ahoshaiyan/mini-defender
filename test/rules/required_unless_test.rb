# frozen_string_literal: true

require 'test_helper'

class RequiredUnlessTest < Minitest::Test
  def setup
    data = {
      'type' => 'personal',
      'usernames' => ['john', 'jane'],
      'address_1' => {
        'country' => 'SA',
        'city' => 'Riyadh',
        'zip' => '12345'
      },
      'address_2' => {
        'country' => 'SA',
        'city' => 'Riyadh',
      }
    }

    @validator = MiniDefender::Validator.new({}, data)
  end

  def test_should_not_require_field_when_target_string_is_present_and_matching
    rule = MiniDefender::Rules::RequiredUnless.new('type', 'personal')
    refute(rule.implicit?(@validator))
  end

  def test_should_require_field_when_target_string_is_not_matching
    rule = MiniDefender::Rules::RequiredUnless.new('type', 'business')
    assert(rule.implicit?(@validator))
  end

  def test_should_not_require_field_when_target_array_contains_value
    rule = MiniDefender::Rules::RequiredUnless.new('usernames', 'john')
    refute(rule.implicit?(@validator))
  end

  def test_should_require_field_when_target_array_does_not_contain_value
    rule = MiniDefender::Rules::RequiredUnless.new('usernames', 'jake')
    assert(rule.implicit?(@validator))
  end

  def test_should_not_require_field_when_target_hash_contains_key
    rule = MiniDefender::Rules::RequiredUnless.new('address_1', 'zip')
    refute(rule.implicit?(@validator))
  end

  def test_should_require_field_when_target_hash_does_not_contain_key
    rule = MiniDefender::Rules::RequiredUnless.new('address_2', 'zip')
    assert(rule.implicit?(@validator))
  end
end
