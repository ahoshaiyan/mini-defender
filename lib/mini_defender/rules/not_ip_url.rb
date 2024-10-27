# frozen_string_literal: true

class MiniDefender::Rules::NotIPURL < MiniDefender::Rule
  PUBLIC_TLDS = %w[
    # Generic
    com org net edu gov mil int

    # Country codes
    sa uk us ca au de fr es it jp cn

    # New generic
    io app dev cloud xyz site web

    # Business/Orgs
    biz info name pro
  ]

  PRIVATE_TLDS = %w[
    test invalid example internal
    corp private lan intranet
  ]

  def self.signature
    'not_ip_url'
  end

  def passes?(attribute, value, validator)
    uri = URI.parse(value.to_s)
    host = uri.host.to_s

    return false if ip_like?(host)
    return false unless valid_domain_format?(host)

    tld = host.split('.').last.downcase
    return false if PRIVATE_TLDS.include?(tld)

    PUBLIC_TLDS.include?(tld) || tld.length >= 2
  rescue URI::InvalidURIError
    false
  end

  def message(attribute, value, validator)
    'URL must be a valid public domain name (not an IP address or private domain)'
  end

  private

  def ip_like?(host)
    # ipv6                ipv4
    host =~ /^[\d:]+$/ || host =~ /^\d{1,3}(\.\d{1,3}){3}$/
  end

  def valid_domain_format?(host)
    host =~ /^[a-z0-9]+([-.]{1}[a-z0-9]+)*\.[a-z]{2,}$/i
  end
end
