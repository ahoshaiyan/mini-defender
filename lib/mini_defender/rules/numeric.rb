# frozen_string_literal: true

class MiniDefender::Rules::Numeric < MiniDefender::Rule
  def self.signature
    'numeric'
  end

  def coerce(value)
    value.is_a?(Numeric) ? value : Float(value.to_s)
  end

  def passes?(attribute, value, validator)
    value.is_a?(Numeric) || Float(value.to_s) rescue false
  end

  def message(attribute, value, validator)
    I18n.t('mini_defender.numeric', attribute: attribute)
  end
end
