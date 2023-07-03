# frozen_string_literal: true

require 'time'

class MiniDefender::Rules::DateEq < MiniDefender::Rule
  def initialize(target_date)
    @target_date = parse_date(target_date)
    @valid_value = false
  end

  def self.signature
    'date_eq'
  end

  def self.make(args)
    raise ArgumentError, 'Target date is required for date rules.' unless args == 1

    self.new(args[0])
  end

  def passes?(attribute, value, validator)
    value = parse_date(value)
    @valid_value = true

    value == @target_date
  rescue ArgumentError
    false
  end

  def message(attribute, value, validator)
    return I18n.t('mini_defender.date') unless @valid_value

    I18n.t('mini_defender.date_eq', attribute: attribute.humanize, target_date: @target_date)
  end

  protected

  def parse_date(date)
    date = date.to_time if date.is_a?(Date)
    date = Time.parse(date) unless date.is_a?(Time)
    date
  end
end
