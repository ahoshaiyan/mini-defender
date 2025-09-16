# frozen_string_literal: true

class MiniDefender::Rules::EnglishString < MiniDefender::Rule
  ENGLISH_REGEX = /^[a-zA-Z ]*$/
  def self.signature
    'english_string'
  end

  def coerce(value)
    value.strip
  end

  def passes?(attribute, value, validator)
    if value.to_s.empty? || !value.is_a?(String)
      return false
    end
    value.to_s.match?(ENGLISH_REGEX)
  end

  def message(attribute, value, validator)
    "The field must only contain english characters."
  end
end