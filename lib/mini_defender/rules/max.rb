# frozen_string_literal: true

class MiniDefender::Rules::Max < MiniDefender::Rule
  def initialize(max)
    @max = max
  end

  def self.signature
    'max'
  end

  def self.make(args)
    self.new(args[0].to_i)
  end

  def passes?(attribute, value, validator)
    case value
    when String, Array, Hash
      value.length <= @max
    when Numeric
      value <= @max
    else
      false
    end
  end

  def message(attribute, value, validator)
    "The #{attribute} field length must be less than or equal to #{@max}."
  end
end
