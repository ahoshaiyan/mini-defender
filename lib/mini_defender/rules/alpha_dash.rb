# frozen_string_literal: true

class MiniDefender::Rules::AlphaDash < MiniDefender::Rule
  def self.signature
    'alpha_dash'
  end

  def passes?(attribute, value, validator)
    value.is_a?(String) && /^[a-zA-Z\-_]+$/.match?(value)
  end

  def message(attribute, value, validator)
    I18n.t('mini_defender.alpha_dash', attribute: attribute.humanize)
  end
end
