# frozen_string_literal: true

class MiniDefender::Rules::Prohibited < MiniDefender::Rule
  def self.signature
    'prohibited'
  end

  def passes?(_attribute, value, _validator)
    value.blank?
  end

  def message(_attribute, _value, _validator)
    'This field is prohibited.'
  end
end
