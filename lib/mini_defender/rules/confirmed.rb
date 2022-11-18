# frozen_string_literal: true

class MiniDefender::Rules::Confirmed < MiniDefender::Rule
  def initialize
    @found = false
  end

  def self.signature
    'confirmed'
  end

  def passes?(attribute, value, validator)
    key = "#{attribute}_confirmation"
    (@found = validator.data.key?(key)) && value == validator.data[key]
  end

  def message(attribute, value, validator)
    if @found
      'The value confirmation does not match.'
    else
      'The value must be confirmed.'
    end
  end
end
