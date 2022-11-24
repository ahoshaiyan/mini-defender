# frozen_string_literal: true

class MiniDefender::Rules::Uuid < MiniDefender::Rule
  def initialize(version = nil)
    raise ArgumentError, 'Expected version to be an integer or nil' unless version.nil? || version.is_a?(Integer)

    @version = version
  end

  def self.signature
    'uuid'
  end

  def self.make(args)
    raise ArgumentError, 'Expected exactly one or zero argument' unless args.length <= 1

    new(args[0]&.to_i)
  end

  def coerce(value)
    value.downcase
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(String) &&
      /^\h{8}-(\h{4}-){3}\h{12}$/i.match?(value) &&
      (@version.nil? || value[14].to_i(16) == @version)
  end

  def message(_attribute, _value, _validator)
    if @version
      "The value should be a valid UUID v#{@version}."
    else
      'The value should be a valid UUID.'
    end
  end
end
