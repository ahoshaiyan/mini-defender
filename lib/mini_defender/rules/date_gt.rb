# frozen_string_literal: true

require_relative 'date_eq'

class MiniDefender::Rules::DateGt < MiniDefender::Rules::DateEq
  def self.signature
    'date_gt'
  end

  def passes?(attribute, value, validator)
    value = parse_date(value)
    @valid_value = true

    value > @target_date
  rescue ArgumentError
    false
  end

  def message(attribute, value, validator)
    return I18n.t('mini_defender.date') unless @valid_value

    I18n.t('mini_defender.date_gt', attribute: attribute.humanize, target_date: @target_date)
  end
end
