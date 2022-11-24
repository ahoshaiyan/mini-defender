# frozen_string_literal: true

require 'uri'

class MiniDefender::Rules::Url < MiniDefender::Rule
  def self.signature
    'url'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String) && URI::DEFAULT_PARSER.make_regexp(%w[http https]).match?(value)
  end

  def message(_attribute, _value, _validator)
    'The field must contain a valid URL.'
  end
end
