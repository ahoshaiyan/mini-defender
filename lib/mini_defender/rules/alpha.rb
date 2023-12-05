# frozen_string_literal: true

class MiniDefender::Rules::Alpha < MiniDefender::Rule
  def self.signature
    'alpha'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && /^[a-zA-Z]+$/.match?(value)
  end

  def message(attribute, value, validator)
    I18n.t('mini_defender.alpha', attribute: attribute.humanize)
  end
end
