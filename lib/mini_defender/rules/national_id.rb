# frozen_string_literal: true

require_relative 'luhn'

class MiniDefender::Rules::NationalId < MiniDefender::Rules::Luhn
  def self.signature
    'national_id'
  end

  def message(attribute, value, validator)
    'The value must be a proper national ID number.'
  end
end
