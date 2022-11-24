# frozen_string_literal: true

class MiniDefender::Rules::Alpha < MiniDefender::Rule
  def self.signature
    'alpha'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String) && /^[a-zA-Z]+$/.match?(value)
  end

  def message(_attribute, _value, _validator)
    'The field must only contain alphabetical characters.'
  end
end
