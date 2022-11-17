# frozen_string_literal: true

require 'ipaddr'

class MiniDefender::Rules::Ip < MiniDefender::Rule
  MODES = %w[any public private]

  def initialize(mode = 'any')
    raise ArgumentError, 'Invalid mode' unless MODES.include?(mode)

    @mode = mode
  end

  def self.signature
    'ip'
  end

  def self.make(args)
    new(args[0] || 'any')
  end

  def passes?(attribute, value, validator)
    ip = IPAddr.new(value.to_s)
    (
      @mode == 'any' ||
      @mode == 'private' && (ip.private? || ip.link_local? || ip.loopback?) ||
      @mode == 'public' && !(ip.private? || ip.link_local? || ip.loopback?)
    )
  rescue IPAddr::InvalidAddressError
    false
  end

  def message(attribute, value, validator)
    case @mode
    when 'public'
      "The value must be a valid public IP address."
    when 'private'
      "The value must be a valid private IP address."
    else
      "The value must be a valid IP address."
    end
  end
end
