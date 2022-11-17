# frozen_string_literal: true

require 'tzinfo'

class MiniDefender::Rules::Timezone < MiniDefender::Rule
  def self.signature
    'timezone'
  end

  def passes?(attribute, value, validator)
    value.is_a?(value) && !!TZInfo::Timezone.get(value)
  rescue TZInfo::InvalidTimezoneIdentifier
    false
  end

  def message(attribute, value, validator)
    'The field should contain a valid time zone value.'
  end
end
