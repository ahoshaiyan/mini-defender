# frozen_string_literal: true

require_relative 'luhn'

class MiniDefender::Rules::NationalId < MiniDefender::Rules::Luhn
  def self.signature
    'national_id'
  end

  def message(_attribute, _value, _validator)
    'The value must be a proper national ID number.'
  end
end
