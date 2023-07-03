# frozen_string_literal: true

class MiniDefender::Rules::Boolean < MiniDefender::Rule
  def self.signature
    'boolean'
  end

  def coerce(value)
    value = value.downcase if value.is_a?(String)
    case value
    when 0, '0', 'no', 'off', 'false'
      false
    when 1, '1', 'yes', 'on', 'true'
      true
    else
      value
    end
  end

  def passes?(attribute, value, validator)
    value = value.downcase if value.is_a?(String)
    value.is_a?(TrueClass) || value.is_a?(FalseClass) ||
      [1, 0, '1', '0', 'yes', 'no', 'on', 'off', 'true', 'false'].include?(value)
  end

  def message(attribute, value, validator)
    I18n.t('mini_defender.boolean', attribute: attribute.humanize)
  end
end
