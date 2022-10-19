# frozen_string_literal: true

class MiniDefender::Rules::Size < MiniDefender::Rule
  def initialize(size)
    @size = size
  end

  def self.signature
    'size'
  end

  def self.make(args)
    self.new(args[0].to_i)
  end

  def passes?(attribute, value, validator)
    case value
    when String, Array, Hash
      value.length == @size
    else
      false
    end
  end

  def message(attribute, value, validator)
    "The value length must be equal to #{@size}."
  end
end
