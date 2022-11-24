# frozen_string_literal: true

require 'json'

class MiniDefender::Rules::Json < MiniDefender::Rule
  def self.signature
    'json'
  end

  def passes?(_attribute, value, _validator)
    JSON.parse(value)
  rescue JSON::ParserError
    false
  end

  def message(_attribute, _value, _validator)
    'The value should be a valid JSON string.'
  end
end
