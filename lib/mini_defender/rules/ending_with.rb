# frozen_string_literal: true

class MiniDefender::Rules::EndingWith < MiniDefender::Rule
  def initialize(fragments)
    unless fragments.is_a?(Array) && !fragments.empty? && fragments.all? { |f| f.is_a?(String) }
      raise ArgumentError, 'Expected an array of strings.'
    end

    @fragments = fragments
  end

  def self.signature
    'ending_with'
  end

  def self.make(args)
    new(args)
  end

  def passes?(_attribute, value, _validator)
    @fragments.any? { |f| value.to_s.end_with?(f) }
  end

  def message(_attribute, _value, _validator)
    if @fragments.length == 1
      "The value should end with #{@fragments[0]}."
    else
      "The value should end with one of the following #{@fragments.join(', ')}."
    end
  end
end
