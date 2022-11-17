# frozen_string_literal: true

class MiniDefender::Rules::MinDigits < MiniDefender::Rule
  def initialize(limit)
    raise ArgumentError, 'Limit must be a string.' unless limit.is_a?(Integer)

    @limit = limit
  end

  def self.signature
    'min_digits'
  end

  def self.make(args)
    raise ArgumentError, 'Expected at least one argument for min_digits.' unless args.length == 1

    new(args[0].to_i)
  end

  def passes?(attribute, value, validator)
    @integers = valid = value.is_a?(Integer) || value.is_a?(String) && value.match?(/^\d+$/)
    valid && value.to_s.length >= @limit
  end

  def message(attribute, value, validator)
    if @integers
      'The field should only contain digits.'
    else
      "The field should have at least #{@limit} digits."
    end
  end
end
