# frozen_string_literal: true

class MiniDefender::Rules::Filled < MiniDefender::Rule
  def self.signature
    'filled'
  end

  def passes?(attribute, value, validator)
    case value
    when String
      !value.strip.empty?
    when Array, Hash
      !value.empty?
    else
      !value.nil?
    end
  end

  def message(attribute, value, validator)
    'The field should not be empty.'
  end
end
