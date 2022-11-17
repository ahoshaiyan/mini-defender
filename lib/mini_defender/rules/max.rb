# frozen_string_literal: true

require_relative 'less_than_or_equal'

class MiniDefender::Rules::Max < MiniDefender::Rules::LessThanOrEqual
  def self.signature
    'max'
  end
end
