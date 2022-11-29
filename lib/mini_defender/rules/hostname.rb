# frozen_string_literal: true

class MiniDefender::Rules::Hostname < MiniDefender::Rule
  HOSTNAME_REGEX = /\A[a-zA-Z0-9][a-zA-Z0-9\-]{1,63}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{1,63})+\.?\z/

  def self.signature
    'hostname'
  end

  def coerce(value)
    value.to_s.downcase.strip
  end

  def passes?(attribute, value, validator)
    value = value.to_s.downcase.strip
    return false if value.length > 255

    value.match?(HOSTNAME_REGEX)
  end

  def message(attribute, value, validator)
    'Invalid hostname.'
  end
end
