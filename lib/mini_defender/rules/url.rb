# frozen_string_literal: true

require 'uri'

class MiniDefender::Rules::Url < MiniDefender::Rule
  def self.signature
    'url'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && URI.regexp(%w[http https]).match?(value)
  end

  def message(attribute, value, validator)
    'The field must contain a valid URL.'
  end
end
