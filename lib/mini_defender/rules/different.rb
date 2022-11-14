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
    self.new(args[0])
  end

  def passes?(attribute, value, validator)
    @found, @other = validator.dig(@other_field)
    @found && value == other
  end

  def message(attribute, value, validator)
    if @found
      "The field does not match \"#{@other}\"."
    else
      "The field must match #{@other_field}."
    end
  end
end
