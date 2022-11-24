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

  def defaults?(_validator)
    true
  end

  def default_value(_validator)
    @default
  end

  def passes?(_attribute, _value, _validator)
    true
  end

  def message(_attribute, _value, _validator)
    'i can haz valuo?.'
  end
end
