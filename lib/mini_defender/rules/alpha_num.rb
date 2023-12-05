# frozen_string_literal: true

class MiniDefender::Rules::AlphaNum < MiniDefender::Rule
  def self.signature
    'alpha_num'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && /^[a-zA-Z0-9]+$/.match?(value)
  end

  def message(attribute, value, validator)
    I18n.t('mini_defender.alpha_num', attribute: attribute.humanize)
  end
end
