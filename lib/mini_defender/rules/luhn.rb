# frozen_string_literal: true

class MiniDefender::Rules::Luhn < MiniDefender::Rule
  def self.signature
    'luhn'
  end

  def self.valid_luhn?(value)
    value = value.to_s
    return false unless value.match?(/\A\d+\z/)

    double_sum = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
    sum = 0

    value.to_i.digits.each_with_index do |digit, index|
      sum += index.even? ? digit : double_sum[digit]
    end

    sum % 10 === 0
  end

  def coerce(value)
    value.to_s
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && self.class.valid_luhn?(value)
  end

  def message(attribute, value, validator)
    'The value must be a valid Luhn string.'
  end
end
