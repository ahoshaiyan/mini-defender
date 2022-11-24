# frozen_string_literal: true

class MiniDefender::Rules::AlphaNum < MiniDefender::Rule
  def self.signature
    'alpha_num'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String) && /^[a-zA-Z0-9]+$/.match?(value)
  end

  def message(_attribute, _value, _validator)
    'The field must only contain alpha-num characters.'
  end
end
