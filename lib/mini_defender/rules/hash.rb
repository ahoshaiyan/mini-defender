# frozen_string_literal: true

class MiniDefender::Rules::Hash < MiniDefender::Rule
  def self.signature
    'hash'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(Hash)
  end

  def message(_attribute, _value, _validator)
    'The field must be an object.'
  end
end
