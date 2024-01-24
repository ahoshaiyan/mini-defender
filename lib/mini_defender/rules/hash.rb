# frozen_string_literal: true

class MiniDefender::Rules::Hash < MiniDefender::Rule
  def self.signature
    'hash'
  end

  def initialize(data_mode = 'none', key_type = 'any', value_type = 'any')
    @data_mode = data_mode
    @key_type = key_type
    @value_type = value_type
  end

  def self.make(args)
    new(
      args[0] || 'none',
      args[1] || 'any',
      args[2] || 'any',
    )
  end

  def priority
    500
  end

  def coerce(value)
    @data_mode == 'all' ? value : {}
  end

  def force_coerce?
    true
  end

  def passes?(attribute, value, validator)
    passes = value.is_a?(Hash)

    unless passes
      return false
    end

    if @key_type == 'string'
      passes &= value.all? { |k, _| k.is_a?(String) }
    end

    case @value_type
      when 'string'
        passes &= value.all? { |_, v| v.is_a?(String) }
      when 'integer'
        passes &= value.all? { |_, v| v.is_a?(Integer) }
      when 'float'
        passes &= value.all? { |_, v| v.is_a?(Float) }
      else
        # None
    end

    passes
  end

  def message(attribute, value, validator)
    additional = ''

    if @key_type != 'any'
      additional += ", key must be #{@key_type}"
    end

    if @value_type != 'any'
      additional += ", value must be #{@value_type}"
    end

    "The field must be an object#{additional}."
  end
end
