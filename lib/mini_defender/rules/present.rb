# frozen_string_literal: true

class MiniDefender::Rules::Present < MiniDefender::Rule
  def self.signature
    'present'
  end

  def implicit?(_validator)
    true
  end

  def passes?(_attribute, _value, _validator)
    true
  end

  def message(_attribute, _value, _validator)
    'The field should be present.'
  end
end
