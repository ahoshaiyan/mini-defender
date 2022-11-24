# frozen_string_literal: true

require 'countries'

class MiniDefender::Rules::CountryCode < MiniDefender::Rule
  COUNTRIES = ISO3166::Country.pluck(:alpha2).flatten

  def self.signature
    'country_code'
  end

  def coerce(value)
    value.strip.upcase
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String) && COUNTRIES.include?(value.strip.upcase)
  end

  def message(_attribute, _value, _validator)
    'The value must be a valid ISO3166 country code.'
  end
end
