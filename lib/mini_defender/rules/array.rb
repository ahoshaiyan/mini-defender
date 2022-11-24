# frozen_string_literal: true

class MiniDefender::Rules::Array < MiniDefender::Rule
  def self.signature
    'array'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(Array)
  end

  def message(_attribute, _value, _validator)
    'The field must be an array.'
  end
end
