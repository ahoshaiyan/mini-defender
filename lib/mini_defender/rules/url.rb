# frozen_string_literal: true

require 'uri'
require 'ipaddr'
require 'public_suffix'

# TODO: ensure rescues
class MiniDefender::Rules::Url < MiniDefender::Rule
  ALLOWED_MODIFIERS = %w[https public not_ip not_private]

  def initialize(modifiers = [])
    @modifiers = Array(modifiers).map(&:to_s)

    unless @modifiers.empty?
      validate_modifiers!
    end

    @validation_error = "URL modifiers list contains only #{ALLOWED_MODIFIERS.join(', ')}."
  end

  def self.signature
    'url'
  end

  def self.make(modifiers) # no need to raise an error when no modifier is entered; as 'url' rule checks URL structure on its own
    new(modifiers)
  end

  def passes?(attribute, value, validator)
    # TODO: warning: URI.regexp is obsolete; use URI::DEFAULT_PARSER.make_regexp instead
    unless value.is_a?(String) && URI::DEFAULT_PARSER.make_regexp(%w[http https]).match?(value)
      return false
    end

    begin
      uri = URI.parse(value)

      if @modifiers.empty?
        return true
      end

      if @modifiers.include?('https') && uri.scheme != 'https'
        @validation_error = 'The URL must use HTTPS.'
        return false
      end

      if @modifiers.include?('public') && (!PublicSuffix.valid?(uri.host) || self.class.private_network?(uri.host))
        @validation_error = 'The URL must use a valid public domain.'
        return false
      end

      if @modifiers.include?('not_ip') && ip_address?(uri.host)
        @validation_error = 'IP addresses are not allowed in URLs.'
        return false
      end

      if @modifiers.include?('not_private') && self.class.private_network?(uri.host)
        @validation_error = 'Private or reserved resources are not allowed.'
        return false
      end

      true
    rescue URI::InvalidURIError
      @validation_error = 'The field must contain a valid URL.'
      false
    rescue PublicSuffix::Error
      false
    end
  end

  def self.private_network?(host)
    unless host
      return false
    end

    host = host.downcase

    private_patterns.any? { |pattern| pattern.match?(host) }
  end

  def message(attribute, value, validator)
    @validation_error || 'The field must contain a valid URL.'
  end

  private

  def validate_modifiers!
    invalid_modifiers = @modifiers - ALLOWED_MODIFIERS
    if invalid_modifiers.empty?
      return
    end

    raise ArgumentError, "Invalid URL modifiers: #{invalid_modifiers.join(', ')}"
  end

  def ip_address?(host)
    unless host
      return false
    end

    begin
      IPAddr.new(host)
      true
    rescue IPAddr::InvalidAddressError
      false
    end
  end

  def self.private_patterns
    @private_patterns ||= begin
      pattern_file = File.expand_path('../data/private_network_patterns.txt', __dir__)
      File.readlines(pattern_file).filter_map do |line|
        line = line.strip

        if line.empty? || line.start_with?('#')
          next
        end

        # Pattern => regex (once)
        pattern = line
                  .gsub('.', '\.')           # escape dots
                  .gsub('*', '.*')           # wildcards => regex
                  .gsub('[0-9]+', '\d+')     # convert number ranges
                  .gsub(/\[(.+?)\]/, '(\1)') # convert chars classes

        Regexp.new("^#{pattern}$", Regexp::IGNORECASE)
      end
    end
  end
end
