# frozen_string_literal: true

require 'action_dispatch'
require_relative 'size'

class MiniDefender::Rules::GreaterThan < MiniDefender::Rules::Size
  def self.signature
    'gt'
  end

  def passes?(attribute, value, validator)
    case value
    when String, Array, Hash
      value.length > @size
    when ActionDispatch::Http::UploadedFile
      value.size > @size
    when Numeric
      value > @size
    else
      false
    end
  end

  def message(attribute, value, validator)
    case value
    when ActionDispatch::Http::UploadedFile
      "The file size must be greater than #{@size} bytes."
    when Numeric
      "The value must be greater than #{@size}."
    else
      I18n.t('mini_defender.gt', attribute: attribute, value: @size)
    end
  end
end
