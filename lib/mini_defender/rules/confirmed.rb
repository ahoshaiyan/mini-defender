# frozen_string_literal: true

class MiniDefender::Rules::Confirmed < MiniDefender::Rule
  def initialize
    @found = false
  end

  def self.signature
    'confirmed'
  end

  def passes?(attribute, value, validator)
    key = "#{attribute}_confirmation"
    (@found = validator.data.key?(key)) && value == validator.data[key]
  end

  def message(attribute, value, validator)
    if @found
      I18n.t('mini_defender.confirmed.found', attribute: attribute.humanize)
    else
      I18n.t('mini_defender.confirmed.not_found', attribute: attribute.humanize)
    end
  end
end
