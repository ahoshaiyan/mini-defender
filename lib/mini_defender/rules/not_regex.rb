# frozen_string_literal: true

class MiniDefender::Rules::NotRegex < MiniDefender::Rule
  def initialize(pattern)
    raise ArgumentError, 'Expected a Regexp instance.' unless pattern.is_a?(Regexp)

    @pattern = pattern
  end

  def self.signature
    'not_regex'
  end

  def self.make(args)
    raise ArgumentError, 'Expected a pattern as input.' unless args.length > 0

    new(Regexp.compile(args.join(',')))
  end

  def passes?(attribute, value, validator)
    !value.to_s.match?(@pattern)
  end

  def message(attribute, value, validator)
    "The value must not match #{@pattern.to_s}."
  end
end
