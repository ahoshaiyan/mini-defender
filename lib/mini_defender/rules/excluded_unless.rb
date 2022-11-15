# frozen_string_literal: true

class MiniDefender::Rules::ExcludedUnless < MiniDefender::Rule
  def initialize(target, value)
    raise ArgumentError, 'Target must be a string' unless target.is_a?(String)

    @target = target
    @value = value
  end

  def self.signature
    'excluded_unless'
  end

  def self.make(args)
    raise ArgumentError, 'Target and expected value are required.' unless args.length == 2

    self.new(args[0], args[1])
  end

  def excluded?(validator)
    ! (validator.data.key?(@target) && validator.data[@target] == @value)
  end

  def passes?(attribute, value, validator)
    true
  end
end
