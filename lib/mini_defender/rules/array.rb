# frozen_string_literal: true

class MiniDefender::Rules::Array < MiniDefender::Rule
  def self.signature
    'array'
  end

  def initialize(data_mode = 'none')
    @data_mode = data_mode
  end

  def self.make(args)
    new(args[0] || 'none')
  end

  def coerce(value)
    @data_mode == 'all' ? value : []
  end

  def force_coerce?
    true
  end

  def passes?(attribute, value, validator)
    value.is_a?(Array)
  end

  def message(attribute, value, validator)
    "The field must be an array."
  end
end
