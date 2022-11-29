# frozen_string_literal: true

class MiniDefender::Rules::Iban < MiniDefender::Rule
  LENGTH_MATRIX = {
    'SA' => 24
  }

  def self.signature
    'iban'
  end

  def coerce(value)
    value.to_s.upcase.gsub(/\s/, '')
  end

  def passes?(attribute, value, validator)
    value = coerce(value)
    value.match?(/[A-Z]{2}\d+/i) && valid_length?(value) && valid_checksum?(value)
  end

  def valid_checksum?(iban)
    iban = "#{iban[4..]}#{letter_code(iban[0])}#{letter_code(iban[1])}#{iban[2..3]}".to_i
    iban % 97 === 1
  end

  def valid_length?(iban)
    iban.length == (LENGTH_MATRIX[iban[0..1]] || iban.length)
  end

  def message(attribute, value, validator)
    "The value should be a valid IBAN."
  end

  private

  def letter_code(letter)
    # letter is assumed to be an upcase ASCII alphabet letter (A-Z)
    letter.ord - 55
  end
end
