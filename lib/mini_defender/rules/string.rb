# frozen_string_literal: true

class MiniDefender::Rules::String < MiniDefender::Rule
  def initialize(mode = 'strict')
    @mode = mode
  end

  def self.signature
    'string'
  end

  def self.make(args)
    new(args[0] || 'strict')
  end

  def coerce(value)
    value.to_s
  end

  def passes?(attribute, value, validator)
    if @mode == 'relaxed'
      value.is_a?(String) ||
        value.is_a?(Integer) ||
        value.is_a?(Float) ||
        value.is_a?(FalseClass) ||
        value.is_a?(TrueClass)
    else
      value.is_a?(String)
    end
  end

  def message(attribute, value, validator)
    "The value must be a string."
  end
end
