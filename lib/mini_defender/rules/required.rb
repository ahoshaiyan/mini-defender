# frozen_string_literal: true

class MiniDefender::Rules::Required < MiniDefender::Rule
  def self.signature
    'required'
  end

  def implicit?
    true
  end

  def passes?(attribute, value, validator)
    true
  end

  def message(attribute, value, validator)
    "This field is required."
  end
end
