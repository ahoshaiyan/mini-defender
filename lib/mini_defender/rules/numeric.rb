# frozen_string_literal: true

class MiniDefender::Rules::Numeric < MiniDefender::Rule
  def self.signature
    'numeric'
  end

  def coerce(value)
    if value.is_a?(Numeric)
      return value
    end

    if value.is_a?(String)
      value = value.gsub(',', '')
    end

    Float(value.to_s)
  end

  def passes?(attribute, value, validator)
    if value.is_a?(Numeric)
      return true
    end

    if value.is_a?(String)
      value = value.gsub(',', '')
    end

    Float(value.to_s) rescue false
  end

  def message(attribute, value, validator)
    "The field must contain a numeric value."
  end
end
