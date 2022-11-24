# frozen_string_literal: true

require 'action_dispatch'
require_relative 'size'

class MiniDefender::Rules::LessThan < MiniDefender::Rules::Size
  def self.signature
    'lt'
  end

  def passes?(_attribute, value, _validator)
    case value
    when String, Array, Hash
      value.length < @size
    when ActionDispatch::Http::UploadedFile
      value.size < @size
    when Numeric
      value < @size
    else
      false
    end
  end

  def message(_attribute, value, _validator)
    case value
    when ActionDispatch::Http::UploadedFile
      "The file size must be less than #{@size} bytes."
    when Numeric
      "The value must be less than #{@size}."
    else
      "The value length must be less than #{@size}."
    end
  end
end
