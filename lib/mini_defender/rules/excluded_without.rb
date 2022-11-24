# frozen_string_literal: true

class MiniDefender::Rules::ExcludedWithout < MiniDefender::Rule
  def initialize(target)
    raise ArgumentError, 'Target must be a string' unless target.is_a?(String)

    @target = target
  end

  def self.signature
    'excluded_without'
  end

  def self.make(args)
    raise ArgumentError, 'Target and expected value are required.' unless args.length == 1

    new(args[0])
  end

  def excluded?(validator)
    !validator.data.key?(@target)
  end

  def passes?(_attribute, _value, _validator)
    true
  end
end
