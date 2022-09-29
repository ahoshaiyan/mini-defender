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

  def bails?
    false
  end

  def coerce(value)
    value
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [Validation::Validator] validator
  def passes?(attribute, value, validator)
    raise NotImplementedError, 'Please use a concrete rule.'
  end

  # @param [Object] attribute
  # @param [Object] value
  # @param [Validation::Validator] validator
  def message(attribute, value, validator)
    raise NotImplementedError, 'Please use a concrete rule.'
  end
end
