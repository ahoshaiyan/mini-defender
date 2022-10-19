# frozen_string_literal: true

class MiniDefender::Rules::DigitsBetween < MiniDefender::Rule
  def initialize(min, max)
    raise ArgumentError, 'Min must be a positive integer' unless min.is_a?(Integer) && min > 0
    raise ArgumentError, 'Max must be a positive integer' unless max.is_a?(Integer) && max > 0

    @min = min
    @max = max
  end

  def self.signature
    'digits_between'
  end

  def self.make(args)
    self.new(args[0].to_i, args[1].to_i)
  end

  def passes?(attribute, value, validator)
    value = value&.to_s

    value.is_a?(String) && /\A[0-9]+\z/.match?(value) && value.length >= @min && value.length <= @max
  end

  def message(attribute, value, validator)
    "The field must contain digits between #{min} and #{max}."
  end
end
