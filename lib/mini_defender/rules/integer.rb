# frozen_string_literal: true

class MiniDefender::Rules::Integer < MiniDefender::Rule
  def self.signature
    'integer'
  end

  def coerce(value)
    value.to_i
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(Integer) || value.is_a?(String) && value.match?(/^\d+$/)
  end

  def message(_attribute, _value, _validator)
    'The value must be an integer.'
  end
end
