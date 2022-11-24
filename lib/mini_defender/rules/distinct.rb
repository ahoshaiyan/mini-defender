# frozen_string_literal: true

class MiniDefender::Rules::Distinct < MiniDefender::Rule
  def self.signature
    'distinct'
  end

  def passes?(attribute, value, validator)
    validator
      .neighbors(attribute)
      .reject { |k, _v| k == attribute }
      .none? { |_, v| v == value }
  end

  def message(_attribute, _value, _validator)
    'The value should be unique.'
  end
end
