# frozen_string_literal: true

class MiniDefender::Rules::ExpiryMonth < MiniDefender::Rule
  def self.signature
    'expiry_month'
  end

  def coerce(value)
    value.to_s.rjust(2, '0')
  end

  def passes?(attribute, value, validator)
    return false unless value.to_s.match?(/^\d{1,2}$/)

    value = value.to_i
    value >= 1 && value <= 12
  end

  def message(attribute, value, validator)
    'Invalid expiry month.'
  end
end
