# frozen_string_literal: true

class MiniDefender::Rules::String < MiniDefender::Rule
  def self.signature
    'string'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String)
  end

  def message(attribute, value, validator)
    "The value must be a string."
  end
end
