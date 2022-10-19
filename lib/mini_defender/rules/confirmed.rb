# frozen_string_literal: true

class MiniDefender::Rules::Confirmed < MiniDefender::Rule
  def initialize
    @found = false
  end

  def self.signature
    'confirmed'
  end

  def passes?(attribute, value, validator)
    @found, confirmation = validator.dig("#{attribute}_confirmation")
    return false unless found

    value == confirmation
  end

  def message(attribute, value, validator)
    if @found
      'The value confirmation does not match.'
    else
      'The value must be confirmed.'
    end
  end
end
