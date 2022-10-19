# frozen_string_literal: true

class MiniDefender::Rule
  def self.signature
    raise NotImplementedError, 'Please use a concrete rule.'
  end

  # @param [Array] args Set of positional arguments
  # @return [MiniDefender::Rule]
  def self.make(args)
    self.new
  end

  def implicit?
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

  def coerce(value)
    value
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [MiniDefender::Validator] validator
  def passes?(attribute, value, validator)
    raise NotImplementedError, 'Please use a concrete rule.'
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [MiniDefender::Validator] validator
  def message(attribute, value, validator)
    raise NotImplementedError, 'Please use a concrete rule.'
  end
end
