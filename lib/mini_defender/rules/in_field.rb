# frozen_string_literal: true

class MiniDefender::Rules::InField < MiniDefender::Rule
  def initialize(field)
    raise ArgumentError, 'Field must be a string.' unless field.is_a?(String)

    @field = field
  end

  def self.signature
    'in_field'
  end

  def self.make(args)
    raise ArgumentError, 'Expected one argument, target field name.' unless args.length == 1

    new(args[0])
  end

  def passes?(attribute, value, validator)
    @field_value = nil
    return false unless validator.data.key(@field)

    @field_value = validator.data[@field]
    return false unless field.is_a?(Array)

    @field_value.include?(value)
  end

  def message(attribute, value, validator)
    case @field_value
    when nil
      "The field (#{@field}) is missing."
    when Array
      "The field (#{@field}) must be an array."
    else
      "The value must be one of the values found in #{@field}."
    end
  end
end
