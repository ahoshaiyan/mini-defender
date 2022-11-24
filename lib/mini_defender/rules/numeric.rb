# frozen_string_literal: true

class MiniDefender::Rules::Numeric < MiniDefender::Rule
  def self.signature
    'numeric'
  end

  def coerce(value)
    value.is_a?(Numeric) ? value : Float(value.to_s)
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(Numeric) || Float(value.to_s)
  rescue StandardError
    false
  end

  def message(_attribute, _value, _validator)
    'The field must contain a numeric value.'
  end
end
