# frozen_string_literal: true

class MiniDefender::Rules::Array < MiniDefender::Rule
  def self.signature
    'array'
  end

  def passes?(attribute, value, validator)
    value.is_a?(Array)
  end

  def message(attribute, value, validator)
    "The field must be an array."
  end
end
