# frozen_string_literal: true

class MiniDefender::Rule
  def self.signature
    raise NotImplementedError, 'Use a concrete implementation.'
  end

  # @param [Array] args Set of positional arguments
  # @return [MiniDefender::Rule]
  def self.make(args)
    self.new
  end

  # @return [Boolean]
  def self.available?
    true
  end

  # @param [MiniDefender::Validator] validator
  # @return [Boolean]
  def implicit?(validator)
    false
  end

  # Instruct the validator to stop validation for the current attribute
  # when the first error is encountered
  def bails?
    false
  end

  # Instructs the validator to stop validation for all rules for the current attribute
  def stops?
    false
  end

  # @param [MiniDefender::Validator] validator
  # @return [Boolean]
  def active?(validator)
    true
  end

  # @param [MiniDefender::Validator]
  # @return [Boolean]
  def excluded?(validator)
    false
  end

  def coerce(value)
    value
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [MiniDefender::Validator] validator
  def passes?(attribute, value, validator)
    raise NotImplementedError, 'Use a concrete implementation.'
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [MiniDefender::Validator] validator
  def message(attribute, value, validator)
    raise NotImplementedError, 'Use a concrete implementation.'
  end
end
