# frozen_string_literal: true

require 'uri'
require 'resolv'
require_relative '../detectors/public_domain_detector'

class MiniDefender::Rules::Url < MiniDefender::Rule
  ALLOWED_MODIFIERS = %w[https_only public no_ip]

  def initialize(modifiers = [])
    @modifiers = Array(modifiers).map(&:to_s)
    validate_modifiers! unless @modifiers.empty?
  end

  def self.signature
    'url'
  end

  def self.make(args)
    new(args)
  end

  def passes?(attribute, value, validator)
    # TODO: warning: URI.regexp is obsolete; use URI::DEFAULT_PARSER.make_regexp instead
    return false unless value.is_a?(String) && URI.regexp(%w[http https]).match?(value)

    begin
      uri = URI.parse(value)

      return true if @modifiers.empty?

      return false if @modifiers.include?('https_only') && uri.scheme != 'https'
      return false if @modifiers.include?('public') &&
                      !MiniDefender::Detectors::PublicDomainDetector.public_domain?(uri.host)
      return false if @modifiers.include?('no_ip') && ip_address?(uri.host)

      true
    rescue URI::InvalidURIError
      false
    end
  end

  def message(_attribute, value, _validator)
    return 'The field must contain a valid URL.' unless value.is_a?(String)

    begin
      uri = URI.parse(value)
      return 'The field must contain a valid URL.' if @modifiers.empty?

      return 'The URL must use HTTPS.' if @modifiers.include?('https_only') && uri.scheme != 'https'

      if @modifiers.include?('public') &&
         !MiniDefender::Detectors::PublicDomainDetector.public_domain?(uri.host)
        return 'The URL must use a valid public domain.'
      end

      return 'IP addresses are not allowed in URLs.' if @modifiers.include?('no_ip') && ip_address?(uri.host)

      'The field must contain a valid URL.'
    rescue URI::InvalidURIError
      'The field must contain a valid URL.'
    end
  end

  private

  def validate_modifiers!
    invalid_modifiers = @modifiers - ALLOWED_MODIFIERS
    return if invalid_modifiers.empty?

    raise ArgumentError, "Invalid URL modifiers: #{invalid_modifiers.join(', ')}"
  end

  def ip_address?(host)
    return false unless host

    !!(host =~ Resolv::IPv4::Regex || host =~ Resolv::IPv6::Regex)
  end
end
