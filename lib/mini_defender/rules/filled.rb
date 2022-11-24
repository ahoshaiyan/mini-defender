# frozen_string_literal: true

class MiniDefender::Rules::Filled < MiniDefender::Rule
  def self.signature
    'filled'
  end

  def passes?(_attribute, value, _validator)
    case value
    when String
      !value.strip.empty?
    when Array, Hash
      !value.empty?
    else
      !value.nil?
    end
  end

  def message(_attribute, _value, _validator)
    'The field should not be empty.'
  end
end
