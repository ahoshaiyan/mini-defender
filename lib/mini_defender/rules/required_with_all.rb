# frozen_string_literal: true

require_relative 'required'

class MiniDefender::Rules::RequiredWithAll < MiniDefender::Rules::Required
  def initialize(targets)
    unless targets.is_a?(Array) && targets.all? { |t| t.is_a?(String) }
      raise ArgumentError, 'Expected an array of strings.'
    end

    @targets = targets
  end

  def self.signature
    'required_with_all'
  end

  def self.make(args)
    raise ArgumentError, 'Expected at least one argument.' unless args.length >= 1

    new(args)
  end

  def implicit?(validator)
    @targets.all? { |t| validator.data.key?(t) }
  end
end
