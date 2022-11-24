# frozen_string_literal: true

class MiniDefender::Rules::String < MiniDefender::Rule
  def self.signature
    'string'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String)
  end

  def message(_attribute, _value, _validator)
    'The value must be a string.'
  end
end
