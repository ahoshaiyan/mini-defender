# frozen_string_literal: true

class MiniDefender::Rules::Different < MiniDefender::Rule
  def initialize(other_field)
    raise ArgumentError, 'Other field must be a string' unless other_field.is_a?(String)

    @found = false
    @other_field = other_field
  end

  def self.signature
    'different'
  end

  def self.make(args)
    new(args[0])
  end

  def passes?(_attribute, value, validator)
    @found = validator.data.key?(@other_field)
    @other = validator.data[@other_field]
    @found && value == @other
  end

  def message(_attribute, _value, _validator)
    if @found
      "The field does not match \"#{@other}\"."
    else
      "The field must match #{@other_field}."
    end
  end
end
