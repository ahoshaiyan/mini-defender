# frozen_string_literal: true

require_relative 'date_eq'

class MiniDefender::Rules::DateLte < MiniDefender::Rules::DateEq
  def self.signature
    'date_lte'
  end

  def passes?(_attribute, value, _validator)
    value = parse_date(value)
    @valid_value = true

    value <= @target_date
  rescue ArgumentError
    false
  end

  def message(_attribute, _value, _validator)
    return 'The given value is not a valid date.' unless @valid_value

    "The value must be less than or equal to #{@target_date}."
  end
end
