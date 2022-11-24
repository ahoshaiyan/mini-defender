# frozen_string_literal: true

class MiniDefender::Rules::AlphaDash < MiniDefender::Rule
  def self.signature
    'alpha_dash'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String) && /^[a-zA-Z\-_]+$/.match?(value)
  end

  def message(_attribute, _value, _validator)
    'The field must only contain alphabetical characters, dashes and underscores.'
  end
end
