# frozen_string_literal: true

class MiniDefender::Rules::Present < MiniDefender::Rule
  def self.signature
    'present'
  end

  def implicit?(validator)
    true
  end

  def passes?(attribute, value, validator)
    true
  end

  def message(attribute, value, validator)
    "The field should be present."
  end
end
