# frozen_string_literal: true

class MiniDefender::Rules::Password < MiniDefender::Rule
  def self.signature
    'password'
  end

  def passes?(attribute, value, validator)
    @errors = []

    # Password requirements
    @errors << I18n.t('mini_defender.password.upper_case') unless /[A-Z]/.match?(value)
    @errors << I18n.t('mini_defender.password.lower_case') unless /[a-z]/.match?(value)
    @errors << I18n.t('mini_defender.password.digit') unless /\d/.match?(value)
    @errors << I18n.t('mini_defender.password.special_characters') unless /[#?!@$%^&*-]+/.match?(value)
    @errors << I18n.t('mini_defender.password.length', min: 8) unless value.length >= 8

    @errors.empty?
  end

  def message(attribute, value, validator)
    @errors.join(', ')
  end
end
