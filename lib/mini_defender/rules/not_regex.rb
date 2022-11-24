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
    raise ArgumentError, 'Expected a pattern as input.' unless args.length == 1

    new(Regexp.compile(args[0]))
  end

  def passes?(_attribute, value, _validator)
    !value.to_s.match?(@pattern)
  end

  def message(_attribute, _value, _validator)
    "The value must not match #{@pattern}."
  end
end
