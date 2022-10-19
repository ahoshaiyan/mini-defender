# frozen_string_literal: true

class MiniDefender::Rules::Accepted < MiniDefender::Rule
  ALLOWED_VALUES = ['yes', 'on', 1, true]

  def self.signature
    'accepted'
  end

  def passes?(attribute, value, validator)
    !value.nil? && ALLOWED_VALUES.include?(value)
  end

  def message(attribute, value, validator)
    "Must be accepted."
  end
end
