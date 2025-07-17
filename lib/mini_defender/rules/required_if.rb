# frozen_string_literal: true

require_relative 'required'

class MiniDefender::Rules::RequiredIf < MiniDefender::Rules::Required
  def initialize(target, value)
    unless target.is_a?(String)
      raise ArgumentError, 'Target must be a string'
    end

    @target = target
    @value = value
  end

  def self.signature
    'required_if'
  end

  def self.make(args)
    unless args.length == 2
      raise ArgumentError, 'Target and expected value are required.'
    end

    self.new(args[0], args[1])
  end

  def implicit?(validator)
    unless validator.data.key?(@target)
      return false
    end

    target_value = validator.data[@target]

    case target_value
      when Array
        target_value.include?(@value)
      when Hash
        target_value.keys.include?(@value)
      else
        target_value == @value
    end
  end
end
