# frozen_string_literal: true

require 'test_helper'

class ArrayTest < Minitest::Test
  def test_array_must_be_reconstructed
    data = {
      "events" => [
        {
          "id" => "5b1b6125-1cb9-48fb-952f-8b9f28d78d1e",
          "date" => "2024-02-20",
          "time" => "00:00",
          "timezone" => "Asia/Riyadh"
        },
        {
          "id" => "8f7bbcec-554b-4e2e-87b0-d5cd2fb2676e",
          "date" => "2024-02-20",
          "time" => "00:00",
          "timezone" => "Asia/Riyadh"
        },
        {
          "id" => "49d44280-ef2b-44ac-82dc-3fca4f64ed25",
          "date" => "2024-02-20",
          "time" => "00:00",
          "timezone" => "Asia/Riyadh"
        }
      ]
    }

    v = MiniDefender::Validator.new({
      'events' => 'required|array|min:1',
      'events.*.id' => 'required|string',
      'events.*.date' => 'required|date',
      'events.*.time' => 'required|date',
      'events.*.timezone' => 'required|timezone',
    }, data)

    assert v.passes?
    assert v.coerced['events'].is_a?(Array)
    assert_equal 3, v.coerced['events'].length
  end
end
