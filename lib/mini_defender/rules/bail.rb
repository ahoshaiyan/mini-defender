# frozen_string_literal: true

class MiniDefender::Rules::Bail < MiniDefender::Rule
  def self.signature
    'bail'
  end

  def bails?
    true
  end

  def passes?(_attribute, _value, _validator)
    true
  end

  def message(_attribute, _value, _validator)
    'i can haz turkey?.'
  end
end
