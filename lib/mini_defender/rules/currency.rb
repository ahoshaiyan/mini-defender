# frozen_string_literal: true

require 'money'

class MiniDefender::Rules::Currency < MiniDefender::Rule
  CURRENCIES = Money::Currency.map(&:iso_code).map(&:upcase).uniq

  def self.signature
    'currency'
  end

  def coerce(value)
    value.strip.upcase
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && CURRENCIES.include?(value.strip.upcase)
  end

  def message(attribute, value, validator)
    'The value must be a valid ISO-4217 currency code.'
  end
end
