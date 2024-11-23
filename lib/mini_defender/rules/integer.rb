# frozen_string_literal: true

class MiniDefender::Rules::Integer < MiniDefender::Rule
  attr_reader :mode
  attr_reader :parsed

  DIGIT_MAP = {
    # Arabic-Indic Digits
    "\u0660" => '0',
    "\u0661" => '1',
    "\u0662" => '2',
    "\u0663" => '3',
    "\u0664" => '4',
    "\u0665" => '5',
    "\u0666" => '6',
    "\u0667" => '7',
    "\u0668" => '8',
    "\u0669" => '9',

    # Extended Arabic-Indic Digits
    "\u06F0" => '0',
    "\u06F1" => '1',
    "\u06F2" => '2',
    "\u06F3" => '3',
    "\u06F4" => '4',
    "\u06F5" => '5',
    "\u06F6" => '6',
    "\u06F7" => '7',
    "\u06F8" => '8',
    "\u06F9" => '9',
  }

  def initialize(mode = 'strict')
    @mode = mode
  end

  def self.signature
    'integer'
  end

  def self.make(args)
    new(args[0] || 'strict')
  end

  def coerce(value)
    @parsed
  end

  def passes?(attribute, value, validator)
    # Avoid converting integers to string and back
    if value.is_a?(Integer)
      @parsed = value
      return true
    end

    # Remove leading zero so Integer will not treat it as octal
    # Handle leading zeros while preserving both + and - signs
    value = value
      .to_s
      .gsub(/^([+-])?0+(?=\d)/, '\1')

    if @mode == 'relaxed'
      value = normalize_digits(value)
    end

    @parsed = Integer(value)
  rescue
    false
  end

  def message(attribute, value, validator)
    "The value must be an integer."
  end

  def normalize_digits(data)
    # Check if arabic digits exist or avoid expensive string creation operation
    unless data.match?(/[\u0660-\u0669\u06F0-\u06F9]/)
      return data
    end

    DIGIT_MAP.each do |k, v|
      data = data.gsub(k, v)
    end

    data
  end
end
