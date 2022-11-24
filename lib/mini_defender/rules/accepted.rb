# frozen_string_literal: true

class MiniDefender::Rules::Accepted < MiniDefender::Rule
  ALLOWED_VALUES = ['yes', 'on', 1, true]

  def self.signature
    'accepted'
  end

  def passes?(_attribute, value, _validator)
    !value.nil? && ALLOWED_VALUES.include?(value)
  end

  def message(_attribute, _value, _validator)
    'Must be accepted.'
  end
end
