# frozen_string_literal: true

require 'ipaddr'

class MiniDefender::Rules::Ipv6 < MiniDefender::Rule
  MODES = %w[any public private]

  def initialize(mode = 'any')
    raise ArgumentError, 'Invalid mode' unless MODES.include?(mode)

    @mode = mode
  end

  def self.signature
    'ipv6'
  end

  def self.make(args)
    new(args[0] || 'any')
  end

  def passes?(_attribute, value, _validator)
    ip = IPAddr.new(value.to_s)
    ip.ipv6? && (
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
      'The value must be a valid public IPv6 address.'
    when 'private'
      'The value must be a valid private IPv6 address.'
    else
      'The value must be a valid IPv6 address.'
    end
  end
end
