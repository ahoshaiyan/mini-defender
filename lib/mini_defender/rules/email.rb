# frozen_string_literal: true

class MiniDefender::Rules::Email < MiniDefender::Rule
  def self.signature
    'email'
  end

  def coerce(value)
    value.strip.downcase
  end

  def passes?(attribute, value, validator)
    value.to_s.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def message(attribute, value, validator)
    I18n.t('mini_defender.email.invalid')
  end
end
