# frozen_string_literal: true

class MiniDefender::Rules::Bail < MiniDefender::Rule
  def self.signature
    'bail'
  end

  def bails?
    true
  end

  def passes?(attribute, value, validator)
    true
  end

  def message(attribute, value, validator)
    "i can haz turkey?."
  end
end
