# frozen_string_literal: true

class MiniDefender::Rules::Default < MiniDefender::Rule
  def initialize(value)
    @default = value
  end

  def self.signature
    'default'
  end

  def self.make(args)
    raise ArgumentError, 'Expected exactly one argument.' unless args.length == 1

    new(args[0])
  end

  def defaults?(validator)
    true
  end

  def default_value(validator)
    @default
  end

  def passes?(attribute, value, validator)
    true
  end

  def message(attribute, value, validator)
    "i can haz valuo?."
  end
end
