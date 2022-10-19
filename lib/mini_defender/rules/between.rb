# frozen_string_literal: true

class MiniDefender::Rules::Between < MiniDefender::Rule
  def initialize(min, max)
    @min = min
    @max = max
  end

  def self.signature
    'between'
  end

  def self.make(args)
    self.new(args[0].to_i, args[1].to_i)
  end

  def passes?(attribute, value, validator)
    case value
    when String, Array, Hash
      @min <= value.length && value.length <= @max
    else
      false
    end
  end

  def message(attribute, value, validator)
    "The value length must be between #{@min} and #{@max}."
  end
end
