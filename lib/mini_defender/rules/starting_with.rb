# frozen_string_literal: true

class MiniDefender::Rules::StartingWith < MiniDefender::Rule
  def initialize(fragments)
    unless fragments.is_a?(Array) && !fragments.empty? && fragments.all? { |f| f.is_a?(String) }
      raise ArgumentError, 'Expected an array of strings.'
    end

    @fragments = fragments
  end

  def self.signature
    'starting_with'
  end

  def self.make(args)
    new(args)
  end

  def passes?(attribute, value, validator)
    @fragments.any? { |f| value.to_s.start_with?(f) }
  end

  def message(attribute, value, validator)
    if @fragments.length == 1
      "The value should start with #{@fragments[0]}."
    else
      "The value should start with one of the following #{@fragments.join(', ')}."
    end
  end
end
