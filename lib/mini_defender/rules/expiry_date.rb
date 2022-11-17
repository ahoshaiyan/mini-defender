# frozen_string_literal: true

class MiniDefender::Rules::ExpiryDate < MiniDefender::Rule
  def self.signature
    'expiry_date'
  end

  def coerce(value)
    "#{@month}/#{@year}"
  end

  def passes?(attribute, value, validator)
    return false unless value.is_a?(String)

    matches = /(\d{2})\s*\/\s*(\d{2,4})/.match(value.strip)
    return false unless matches
    pp matches

    @month = matches[1].to_i
    @year = matches[2].to_i
    @year += 2000 if year < 100

    @month >= 1 && @month <= 12 && @year >= 1900
  end

  def message(attribute, value, validator)
    'Invalid expiry date.'
  end
end
