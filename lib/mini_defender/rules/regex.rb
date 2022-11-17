# frozen_string_literal: true

class MiniDefender::Rules::Regex < MiniDefender::Rule
  def initialize(pattern)
    raise ArgumentError, 'Expected a Regexp instance.' unless pattern.is_a?(Regexp)

    @pattern = pattern
  end

  def self.signature
    'regex'
  end

  def self.make(args)
    raise ArgumentError, 'Expected a pattern as input.' unless args.length == 1

    new(Regexp.compile(args[0]))
  end

  def passes?(attribute, value, validator)
    value.to_s.match?(@pattern)
  end

  def message(attribute, value, validator)
    "The value must match #{@pattern.to_s}."
  end
end
