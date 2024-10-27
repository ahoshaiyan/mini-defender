# frozen_string_literal: true

require 'test_helper'

class NotIPURLTest < Minitest::Test
  def setup
    @rule = MiniDefender::Rules::NotIPURL.new
  end

  def test_signature
    assert_equal 'not_ip_url', MiniDefender::Rules::NotIPURL.signature
  end

  def test_should_reject_IPv4_addresses
    ipv4_addresses = [
      'http://192.168.1.1',
      'https://10.0.0.1',
      'http://172.16.0.1',
      'https://127.0.0.1',
      'http://0.0.0.0',
      'https://255.255.255.255',
      'http://169.254.169.254',  # AWS metadata endpoint
      'https://192.0.2.1',       # Documentation range
      'http://198.51.100.1',     # Documentation range
      'https://203.0.113.1'      # Documentation range
    ]

    ipv4_addresses.each do |url|
      refute @rule.passes?(:url, url, nil),
             "Expected IPv4 address #{url} to be invalid"
    end
  end

  def test_should_reject_IPv6_addresses
    ipv6_addresses = [
      'http://[2001:db8:85a3:8d3:1319:8a2e:370:7348]',
      'https://[::1]',
      'http://[fe80::1]',
      'https://[2001:db8::1]',
      'http://[2001:0db8:85a3:0000:0000:8a2e:0370:7334]',
      'https://[fe80::217:f2ff:fe07:ed62]',
      'http://[2001:db8::2:1]',
      'https://[2001:db8:0:1:1:1:1:1]',
      'http://[::ffff:192.0.2.128]', # IPv4-mapped IPv6
      'https://[64:ff9b::192.0.2.128]' # IPv4-IPv6 translation
    ]

    ipv6_addresses.each do |url|
      refute @rule.passes?(:url, url, nil),
             "Expected IPv6 address #{url} to be invalid"
    end
  end

  def test_should_reject_IPLike_formats
    ip_like_formats = [
      'http://300.168.1.1',     # Invalid IPv4 octet
      'https://192.168.001.1',  # Leading zeros
      'http://192.168.1',       # Incomplete IPv4
      'https://192.168.1.1.1',  # Extra octet
      'http://[2001:db8::/32]', # CIDR notation
      'https://[2001:db8:1]',   # Incomplete IPv6
      'http://0177.0.0.1',      # Octal format
      'https://0x7f.0.0.1',     # Hexadecimal format
      'http://[::1]/24',        # IPv6 with subnet
      'https://192.168.1.1:80'  # IP with port
    ]

    ip_like_formats.each do |url|
      refute @rule.passes?(:url, url, nil), "Expected IP-like format #{url} to be invalid"
    end
  end

  def test_should_accept_valid_hostnames_that_look_like_IPs
    valid_ip_like_domains = [
      'http://123.com',
      'https://123.456.com',
      'http://123-456.com',
      'https://1234.domain.com',
      'http://ip-192-168-1-1.domain.com'
    ]

    valid_ip_like_domains.each do |url|
      assert @rule.passes?(:url, url, nil),
             "Expected valid domain #{url} to pass validation"
    end
  end

  def test_should_reject_special_IP_addresses
    special_ips = [
      'http://0.0.0.0',         # All zeros
      'https://255.255.255.255', # Broadcast
      'http://127.0.0.1',       # Localhost
      'https://169.254.0.1',    # Link-local
      'http://192.0.0.1',       # IANA special
      'https://192.0.2.1',      # TEST-NET-1
      'http://198.18.0.1',      # Benchmark
      'https://224.0.0.1',      # Multicast
      'http://[::1]',           # IPv6 localhost
      'https://[fe80::1]'       # IPv6 link-local
    ]

    special_ips.each do |url|
      refute @rule.passes?(:url, url, nil),
             "Expected special IP #{url} to be invalid"
    end
  end

  def test_should_handle_IP_addresses_with_ports_and_paths
    ip_with_extras = [
      'http://192.168.1.1:8080',
      'https://192.168.1.1/path',
      'http://192.168.1.1:443/api',
      'https://[::1]:8080',
      'http://[2001:db8::1]/path',
      'https://192.168.1.1:8080/path?query=true',
      'http://[::1]:443/api#fragment'
    ]

    ip_with_extras.each do |url|
      refute @rule.passes?(:url, url, nil),
             "Expected IP with extras #{url} to be invalid"
    end
  end
end
