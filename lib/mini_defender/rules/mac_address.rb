# frozen_string_literal: true

class MiniDefender::Rules::MacAddress < MiniDefender::Rule
  MODES = %w[any local universal]

  def initialize(mode = 'any')
    raise ArgumentError, 'Invalid mode' unless MODES.include?(mode)

    @mode = mode
  end

  def self.signature
    'mac'
  end

  def self.make(args)
    new(args[0] || 'any')
  end

  def passes?(_attribute, value, _validator)
    clean = value.to_s.gsub(/[-:]/)
    clean.match?(/[0-9A-F]{12}/i) && (
      @mode == 'any' ||
      @mode == 'local' && (clean.hex & 0x020000000000 > 0) ||
      @mode == 'universal' && (clean.hex & 0x020000000000 == 0)
    )
  end

  def message(_attribute, _value, _validator)
    case @mode
    when 'local'
      'The value must be a locally administrated MAC address.'
    when 'universal'
      'The value must be a universally administrated MAC address.'
    else
      'The value must be a properly formatted mac address.'
    end
  end
end
