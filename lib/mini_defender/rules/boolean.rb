# frozen_string_literal: true

class MiniDefender::Rules::Boolean < MiniDefender::Rule
  def self.signature
    'boolean'
  end

  def coerce(value)
    case value
    when 0, '0'
      false
    when 1, '1'
      true
    else
      value
    end
  end

  def passes?(attribute, value, validator)
    value.is_a?(TrueClass) || value.is_a?(FalseClass) || [1, 0, '1', '0'].include?(value)
  end

  def message(attribute, value, validator)
    "The value must be a boolean."
  end
end
