# frozen_string_literal: true

require 'ipaddr'

class MiniDefender::Rules::Ipv4 < MiniDefender::Rule
  MODES = %w[any public private]

  def initialize(mode = 'any')
    raise ArgumentError, 'Invalid mode' unless MODES.include?(mode)

    @mode = mode
  end

  def self.signature
    'ipv4'
  end

  def self.make(args)
    new(args[0] || 'any')
  end

  def passes?(_attribute, value, _validator)
    ip = IPAddr.new(value.to_s)
    ip.ipv4? && (
      @mode == 'any' ||
      @mode == 'private' && (ip.private? || ip.link_local? || ip.loopback?) ||
      @mode == 'public' && !(ip.private? || ip.link_local? || ip.loopback?)
    )
  rescue IPAddr::InvalidAddressError
    false
  end

  def message(_attribute, _value, _validator)
    case @mode
    when 'public'
      'The value must be a valid public IPv4 address.'
    when 'private'
      'The value must be a valid private IPv4 address.'
    else
      'The value must be a valid IPv4 address.'
    end
  end
end
