# frozen_string_literal: true

class MiniDefender::Rules::Digits < MiniDefender::Rule
  def initialize(size)
    raise ArgumentError, 'Size must be a positive integer' unless size.is_a?(Integer) && size > 0

    @size = size
  end

  def self.signature
    'digits'
  end

  def self.make(args)
    self.new(args[0].to_i)
  end

  def passes?(attribute, value, validator)
    value = value&.to_s
    value.is_a?(String) && /\A[0-9]+\z/.match?(value) && value.length == @size
  end

  def message(attribute, value, validator)
    "The field must contain #{@size} digits."
  end
end
