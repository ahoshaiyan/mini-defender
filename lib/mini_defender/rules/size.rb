# frozen_string_literal: true

class MiniDefender::Rules::Size < MiniDefender::Rule
  def initialize(size)
    raise ArgumentError, 'Size must be an integer.' unless size.is_a?(Integer)

    @size = size
  end

  def self.signature
    'size'
  end

  def self.make(args)
    raise ArgumentError, 'Expected exactly one argument.' unless args.length == 1

    self.new(args[0].to_i)
  end

  def passes?(attribute, value, validator)
    case value
    when String, Array, Hash
      value.length == @size
    when ActionDispatch::Http::UploadedFile
      value.size == @size
    when Numeric
      value == @size
    else
      false
    end
  end

  def message(attribute, value, validator)
    case value
    when ActionDispatch::Http::UploadedFile
      "The file size must be equal to #{@size} bytes."
    when Numeric
      "The value must be equal to #{@size}."
    else
      "The value length must be equal to #{@size}."
    end
  end
end
