# frozen_string_literal: true

class MiniDefender::Rules::ProhibitedIf < MiniDefender::Rule
  def initialize(target, value)
    raise ArgumentError, 'Target must be a string' unless target.is_a?(String)

    @target = target
    @value = value
  end

  def self.signature
    'prohibited_if'
  end

  def self.make(args)
    raise ArgumentError, 'Target and expected value are required.' unless args.length == 2

    self.new(args[0], args[1])
  end

  def active?(validator)
    validator.data.key?(@target) && validator.data[@target] == @value
  end

  def passes?(attribute, value, validator)
    value.blank?
  end

  def message(attribute, value, validator)
    "This field is prohibited."
  end
end
