# frozen_string_literal: true

require_relative 'declined'

class MiniDefender::Rules::DeclinedIf < MiniDefender::Rules::Declined
  def initialize(target, value)
    raise ArgumentError, 'Target must be a string' unless target.is_a?(String)

    @target = target
    @value = value
  end

  def self.signature
    'declined_if'
  end

  def self.make(args)
    raise ArgumentError, 'Target and expected value are required.' unless args.length == 2

    new(args[0], args[1])
  end

  def active?(validator)
    validator.data[@target] == @value
  end
end
