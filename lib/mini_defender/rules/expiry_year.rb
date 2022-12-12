# frozen_string_literal: true

class MiniDefender::Rules::ExpiryYear < MiniDefender::Rule
  def self.signature
    'expiry_year'
  end

  def coerce(value)
    value = value.to_i
    value += century if value < 100
    value.to_s
  end

  def passes?(attribute, value, validator)
    return false unless value.to_s.match?(/^(\d{2}|\d{4})$/)

    value = value.to_i
    value += century if value < 100
    value >= 1900
  end

  def message(attribute, value, validator)
    'Invalid expiry year.'
  end

  private

  # @param [Integer]
  def century
    year = Time.now.year
    year - (year % 100)
  end
end
