# frozen_string_literal: true

require 'test_helper'

class ExpiryDateTest < Minitest::Test
    def setup
        @rule = MiniDefender::Rules::ExpiryDate.new
    end

    def test_signature
        assert_equal 'expiry_date', MiniDefender::Rules::ExpiryDate.signature
    end

    def test_passes_with_valid_dates
        assert_equal @rule.passes?('expiry', '12/25', nil), true
        assert_equal @rule.passes?('expiry', '01 / 2030', nil), true
        assert_equal @rule.passes?('expiry', ' 06/99 ', nil) , true
    end

    def test_passes_with_invalid_dates
        assert_equal @rule.passes?('expiry', '13/25', nil), false
        assert_equal @rule.passes?('expiry', '00/2025', nil), false
        assert_equal @rule.passes?('expiry', '11-2025', nil), false
        assert_equal @rule.passes?('expiry', 'abcd', nil), false
        assert_equal @rule.passes?('expiry', '06/1899', nil), false
    end

    def test_message
        assert_equal 'Invalid expiry date.', @rule.message('expiry', '13/25', nil)
    end

    def test_coerce
        @rule.passes?('expiry', '06/25', nil)
        assert_equal '6/2025', @rule.coerce(nil)
    end
end
