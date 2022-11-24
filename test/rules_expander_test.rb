# frozen_string_literal: true

require 'test_helper'

class RulesExpanderTest < Minitest::Test
  def setup
    @rules = {
      'username' => 'required|string',
      'password' => %w[required string],
      'addresses' => 'array',
      'addresses.*.streets' => 'array|max:3',
      'addresses.*.streets.*' => 'string',
      'addresses.*.city' => 'required|string',
      'addresses.*.province' => 'string',
      'addresses.*.country' => 'required|string',
      'books' => 'array',
      'books.*' => ['string', 'max:255']
    }

    @data = {
      'username' => 'johndoe',
      'password' => '123123',
      'addresses' => [
        {
          'city' => 'Riyadh',
          'province' => 'Riyadh',
          'country' => 'SA',
          'streets' => %w[s1 s2 s3]
        }
      ]
    }
  end

  def test_should_generate_multiple_rules_for_arrays
    expander = MiniDefender::RulesExpander.new
    expanded_rules = expander.expand(@rules, @data.flatten_keys(keep_roots: true))

    expected = {
      'username' => 'required|string',
      'password' => %w[required string],
      'addresses' => 'array',
      'addresses.0.streets' => 'array|max:3',
      'addresses.0.streets.0' => 'string',
      'addresses.0.streets.1' => 'string',
      'addresses.0.streets.2' => 'string',
      'addresses.0.city' => 'required|string',
      'addresses.0.province' => 'string',
      'addresses.0.country' => 'required|string',
      'books' => 'array',
      'books.0' => ['string', 'max:255']
    }

    assert_equal expected.keys.sort, expanded_rules.keys.sort

    expected.each do |k, rules|
      assert_equal rules, expanded_rules[k]
    end
  end
end
