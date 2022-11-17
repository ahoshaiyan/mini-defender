# frozen_string_literal: true

class MiniDefender::Rules::In < MiniDefender::Rule
  def initialize(values)
    raise ArgumentError, 'Expected an array of values.' unless values.is_a?(Array)

    @values = values
  end

  def self.signature
    'in'
  end

  def self.make(args)
    raise ArgumentError, 'Expected at least one argument.' unless args.length > 0

    new(args)
  end

  def passes?(attribute, value, validator)
    @values.include?(value)
  end

  def message(attribute, value, validator)
    "The value must be one of #{@values.to_sentence}."
  end
end
