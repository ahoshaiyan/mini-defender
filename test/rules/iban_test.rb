# frozen_string_literal: true

require 'test_helper'

class IbanTest < Minitest::Test
  def test_can_validate_iban_with_letters
    rule = MiniDefender::Rules::Iban.new
    assert rule.passes?('iban', 'SA963600000000001234ABCD', nil)
  end
end
