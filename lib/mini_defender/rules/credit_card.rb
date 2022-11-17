# frozen_string_literal: true

require_relative 'luhn'

class MiniDefender::Rules::CreditCard < MiniDefender::Rules::Luhn
  def self.signature
    'credit_card'
  end

  def message(attribute, value, validator)
    'The value must be a proper credit/debit card number.'
  end
end
