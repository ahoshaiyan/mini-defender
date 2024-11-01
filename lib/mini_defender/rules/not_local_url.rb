# frozen_string_literal: true

class MiniDefender::Rules::NotLocalURL < MiniDefender::Rule
  LOCALHOST_PATTERNS = [
    /^localhost$/i,     # localhost, LOCALHOST
    /^127\./,           # 127.x.x.x
    /^::1$/,           # IPv6 localhost
    /^0\.0\.0\.0$/,    # All interfaces IPv4
    /^::$/,            # IPv6 unspecified
    /\.local$/i,       # domain.local
    /^local\./i,       # local.domain
    /^localhost\./i,   # localhost.anything
  ]

  def self.signature
    'not_local_url'
  end

  def passes?(attribute, value, validator)
    uri = URI.parse(value.to_s)
    host = uri.host.to_s.downcase

    !LOCALHOST_PATTERNS.any? { |pattern| host.match?(pattern) }
  rescue URI::InvalidURIError
    false
  end

  def message(attribute, value, validator)
    'URL cannot point to localhost or local domain.'
  end
end