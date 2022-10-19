# frozen_string_literal: true

class MiniDefender::Rules::Declined < MiniDefender::Rule
  ALLOWED_VALUES = ['no', 'off', 0, false]

  def self.signature
    'declined'
  end

  def passes?(attribute, value, validator)
    !value.nil? && ALLOWED_VALUES.include?(value)
  end

  def message(attribute, value, validator)
    "Must be declined."
  end
end
