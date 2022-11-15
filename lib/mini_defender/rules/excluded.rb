# frozen_string_literal: true

class MiniDefender::Rules::Excluded < MiniDefender::Rule
  def self.signature
    'excluded'
  end

  def excluded?(validator)
    true
  end

  def passes?(attribute, value, validator)
    true
  end
end
