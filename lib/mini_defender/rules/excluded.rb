# frozen_string_literal: true

class MiniDefender::Rules::Excluded < MiniDefender::Rule
  def self.signature
    'excluded'
  end

  def excluded?(_validator)
    true
  end

  def passes?(_attribute, _value, _validator)
    true
  end
end
