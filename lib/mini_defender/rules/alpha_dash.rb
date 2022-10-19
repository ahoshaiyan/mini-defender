# frozen_string_literal: true

class MiniDefender::Rules::AlphaDash < MiniDefender::Rules::DateEq
  def self.signature
    'alpha_dash'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && /^[a-zA-Z\-_]+$/.match?(value)
  end

  def message(attribute, value, validator)
    'The field must only contain alphabetical characters, dashes and underscores.'
  end
end
