# frozen_string_literal: true

class MiniDefender::Rules::Integer < MiniDefender::Rule
  def self.signature
    'integer'
  end

  def coerce(value)
    Integer(value)
  end

  def passes?(attribute, value, validator)
    Integer(value.to_s)
  rescue
    false
  end  

  def message(attribute, value, validator)
    "The value must be an integer."
  end
end
