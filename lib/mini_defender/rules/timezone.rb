# frozen_string_literal: true

require 'tzinfo'

class MiniDefender::Rules::Timezone < MiniDefender::Rule
  def self.signature
    'timezone'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String) && !!TZInfo::Timezone.get(value)
  rescue TZInfo::InvalidTimezoneIdentifier
    false
  end

  def message(_attribute, _value, _validator)
    'The field should contain a valid time zone value.'
  end
end
