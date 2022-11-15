# frozen_string_literal: true

class MiniDefender::Rules::Distinct < MiniDefender::Rule
  def self.signature
    'distinct'
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [MiniDefender::Validator] validator
  def passes?(attribute, value, validator)
    validator
      .neighbors(attribute)
      .reject { |k, v| k == attribute }
      .none? { |_, v| v == value }
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [MiniDefender::Validator] validator
  def message(attribute, value, validator)
    'The value should be unique.'
  end
end
