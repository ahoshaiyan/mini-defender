# frozen_string_literal: true

require 'test_helper'

class DataDiggerTest < Minitest::Test
  def setup
    @digger = MiniDefender::DataDigger.new
    @data = {
      'name' => 'Sir John Maxwell Doe',
      'age' => 89,
      'props' => {
        'fat' => false,
        'healthy' => true,
        'bank_account' => 'US-1234',
        'home_address' => {
          'potato' => 'pohtato'
        }
      },
      'addresses' => [
        { 'city' => 'Langley Falls', 'state' => 'West Virginia', 'country' => 'USA' },
        { 'city' => 'London', 'state' => 'Bigger London', 'country' => 'UK' },
      ]
    }
  end

  def test_fetching_root_element
    found, value = @digger.dig(@data, 'name')

    assert found
    assert_equal 'Sir John Maxwell Doe', value
  end

  def test_fetching_root_element_2_electric_boogaloo
    found, value = @digger.dig(@data, 'age')

    assert found
    assert_equal 89, value
  end

  def test_fetching_second_level_element
    found, value = @digger.dig(@data, 'props.healthy')

    assert found
    assert_equal true, value
  end

  def test_fetching_third_level_element
    found, value = @digger.dig(@data, 'props.home_address.potato')

    assert found
    assert_equal 'pohtato', value
  end

  def test_fetching_array
    found, value = @digger.dig(@data, 'addresses')

    assert found
    assert_kind_of Array, value
  end

  def test_fetching_array_element
    found, value = @digger.dig(@data, 'addresses.1')

    assert found
    assert_kind_of Hash, value
  end

  def test_fetching_array_deep_element
    found, value = @digger.dig(@data, 'addresses.0.state')

    assert found
    assert_equal 'West Virginia', value
  end
end
