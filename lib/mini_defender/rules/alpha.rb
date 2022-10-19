# frozen_string_literal: true

class MiniDefender::Rules::Alpha < MiniDefender::Rules::DateEq
  def self.signature
    'alpha'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && /^[a-zA-Z]+$/.match?(value)
  end

  def message(attribute, value, validator)
    'The field must only contain alphabetical characters.'
  end
end
