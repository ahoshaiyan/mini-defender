# frozen_string_literal: true

class MiniDefender::Rules::Declined < MiniDefender::Rule
  ALLOWED_VALUES = ['no', 'off', 0, false]

  def self.signature
    'declined'
  end

  def passes?(_attribute, value, _validator)
    !value.nil? && ALLOWED_VALUES.include?(value)
  end

  def message(_attribute, _value, _validator)
    'Must be declined.'
  end
end
