# frozen_string_literal: true

require_relative 'size'

class MiniDefender::Rules::NotEqual < MiniDefender::Rules::Size
  def self.signature
    'not_equal'
  end

  def passes?(attribute, value, validator)
    !super
  end

  def message(attribute, value, validator)
    super.gsub('must', 'must not')
  end
end
