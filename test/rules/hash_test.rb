# frozen_string_literal: true

require 'test_helper'

class HashTest < Minitest::Test
  def test_hash_should_not_return_additional_keys_by_default
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash',
        'metadata.foo' => 'required|string'
      },
      {
        'metadata' => {
          'foo' => 'bar',
          'zee' => 'mee'
        }
      }
    )

    assert validator.passes?

    assert_equal 1, validator.coerced['metadata'].length
    assert_equal 'bar', validator.coerced['metadata']['foo']
  end

  def test_hash_should_return_additional_keys_when_all_specified
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash:all',
        'metadata.foo' => 'required|string'
      },
      {
        'metadata' => {
          'foo' => 'bar',
          'zee' => 'mee'
        }
      }
    )

    assert validator.passes?

    assert_equal 2, validator.coerced['metadata'].length
    assert_equal 'bar', validator.coerced['metadata']['foo']
    assert_equal 'mee', validator.coerced['metadata']['zee']
  end

  def test_hash_should_fail_when_string_key_type_specified_and_other_provided
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash:all,string'
      },
      {
        'metadata' => {
          0 => 'bar',
          'zee' => 'mee'
        }
      }
    )

    assert !validator.passes?
  end

  def test_hash_should_success_when_string_key_type_specified_and_string_provided
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash:all,string'
      },
      {
        'metadata' => {
          'foo' => 'bar',
          'zee' => 'mee'
        }
      }
    )

    assert validator.passes?
  end

  def test_hash_should_fail_when_integer_value_type_specified_and_other_provided
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash:all,string,integer'
      },
      {
        'metadata' => {
          'foo' => 1,
          'zee' => 'mee'
        }
      }
    )

    assert !validator.passes?
  end

  def test_hash_should_success_when_integer_value_type_specified_and_integer_provided
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash:all,string,integer'
      },
      {
        'metadata' => {
          'foo' => 1,
          'zee' => 2
        }
      }
    )

    assert validator.passes?
  end

  def test_hash_must_return_all_elements_when_all_mode_is_used
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash:all,string,integer'
      },
      {
        'metadata' => {
          'foo' => 1,
          'zee' => 2
        }
      }
    )

    assert validator.coerced['metadata'].is_a?(Hash)
    assert_equal 2, validator.coerced['metadata'].length

    assert_equal 1, validator.coerced['metadata']['foo']
    assert_equal 2, validator.coerced['metadata']['zee']
  end

  def test_hash_must_return_all_elements_when_all_mode_is_used_2
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash:all,string,string'
      },
      {
        'metadata' => {
          '1' => 'foo',
          '2' => 'bar'
        }
      }
    )

    assert validator.coerced['metadata'].is_a?(Hash)
    assert_equal 2, validator.coerced['metadata'].length

    assert_equal 'foo', validator.coerced['metadata']['1']
    assert_equal 'bar', validator.coerced['metadata']['2']
  end

  def test_hash_should_be_delayed_to_all_size_rules_validation
    validator = MiniDefender::Validator.new(
      {
        'metadata' => 'required|hash|size:2|max:2|min:2',
        'metadata.foo' => 'required|string',
        'metadata.zee' => 'required|string'
      },
      {
        'metadata' => {
          'foo' => 'bar',
          'zee' => 'mee'
        }
      }
    )

    assert validator.passes?

    assert_equal 2, validator.coerced['metadata'].length
    assert_equal 'bar', validator.coerced['metadata']['foo']
  end
end
