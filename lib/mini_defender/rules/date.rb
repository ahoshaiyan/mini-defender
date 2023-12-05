# frozen_string_literal: true

require 'time'

class MiniDefender::Rules::Date < MiniDefender::Rule
  def self.signature
    'date'
  end

  def passes?(attribute, value, validator)
    parse_date(value).is_a?(Time)
  rescue ArgumentError
    false
  end

  def message(attribute, value, validator)
    I18n.t('mini_defender.date', attribute: attribute.humanize)
  end

  protected

  def parse_date(date)
    date = date.to_time if date.is_a?(Date)
    date = Time.parse(date) unless date.is_a?(Time)
    date
  end
end
