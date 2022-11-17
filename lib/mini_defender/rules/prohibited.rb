# frozen_string_literal: true

class MiniDefender::Rules::Prohibited < MiniDefender::Rule
  def self.signature
    'prohibited'
  end

  def passes?(attribute, value, validator)
    value.blank?
  end

  def message(attribute, value, validator)
    "This field is prohibited."
  end
end
