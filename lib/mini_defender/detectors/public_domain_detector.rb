# frozen_string_literal: true

module MiniDefender
  module Detectors
    class PublicDomainDetector
      DOT = '.'

      class << self
        def public_domain?(host)
          return false unless host

          instance.valid?(host)
        end

        def instance
          @instance ||= new
        end
      end

      def initialize
        @tlds = Set.new
        @special_suffixes = Set.new
        @local_patterns = Set.new
        load_patterns
      end

      def valid?(host)
        return false unless host && valid_format?(host)

        host = host.to_s.downcase.strip

        return false if local_network?(host)

        parts = host.split(DOT)
        return false if parts.length < 2 # must have at least SLD + TLD; a domain composed by a TLD, SLD and TRD

        return true if valid_special_suffix?(parts) # special suffixes first (e.g., co.uk or herokuapp.com)

        # for normal domains, validate TLD and ensure SLD exists
        tld = parts.last
        sld = parts[-2]

        return false unless @tlds.include?(tld)
        return false unless valid_label?(sld)

        true
      end

      private

      def load_patterns
        load_public_patterns
        load_local_patterns
      end

      def load_public_patterns
        pattern_file = File.expand_path('../data/public_domain_patterns.txt', __dir__)

        File.readlines(pattern_file).each do |line|
          line = line.strip
          next if line.empty? || line.start_with?('#')

          if line.include?(DOT)
            @special_suffixes << line # e.g., "co.uk", "herokuapp.com"
          else
            @tlds << line # e.g., "com"
          end
        end
      end

      def load_local_patterns
        pattern_file = File.expand_path('../data/private_network_patterns.txt', __dir__)

        File.readlines(pattern_file).each do |line|
          line = line.strip
          next if line.empty? || line.start_with?('#')

          @local_patterns << parse_pattern(line)
        end
      end

      def valid_format?(host)
        return false if host.include?('..') # consecutive dots
        return false if host.start_with?(DOT) || host.end_with?(DOT)
        return false if host.start_with?('-') || host.end_with?('-')
        return false if host =~ /[^a-z0-9\-.]/i # only allow valid chars
        return false if host =~ /^xn--/ # punycode

        true
      end

      def valid_label?(label)
        return false unless label
        return false if label.length < 1 || label.length > 63
        return false if label.include?('--') # consecutive hyphens

        true
      end

      def valid_special_suffix?(parts)
        return false if parts.length < 2

        (2..parts.length).each do |i| # try increasingly longer suffixes
          suffix = parts[-i..-1].join(DOT)
          return true if @special_suffixes.include?(suffix)
        end

        false
      end

      def local_network?(host)
        @local_patterns.any? { |pattern| pattern_match?(pattern, host) }
      end

      def parse_pattern(pattern) # pattern to regex
        pattern = pattern
                  .gsub('.', '\.')           # escape dots
                  .gsub('*', '.*')           # wildcards -> regex
                  .gsub('[0-9]+', '\d+')     # number ranges
                  .gsub(/\[(.+?)\]/, '(\1)') # character classes

        Regexp.new("^#{pattern}$", Regexp::IGNORECASE)
      end

      def pattern_match?(pattern, host)
        pattern.match?(host)
      end
    end
  end
end
