# frozen_string_literal: true

class MiniDefender::Rules::Hostname < MiniDefender::Rule
  HOSTNAME_REGEX = /\A([a-zA-Z0-9][a-zA-Z0-9\-]{,62})(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,62})+\.?\z/

  def self.signature
    'hostname'
  end

  def coerce(value)
    value.to_s
      .downcase
      .strip
      .gsub(/\.\z/, '')
  end

  def passes?(attribute, value, validator)
    value = value.to_s.downcase.strip
    if value.length > 255
      return false
    end

    value.match?(HOSTNAME_REGEX)
  end

  def message(attribute, value, validator)
    'Invalid hostname.'
  end
end
