# frozen_string_literal: true

require_relative 'greater_than_or_equal'

class MiniDefender::Rules::Min < MiniDefender::Rules::GreaterThanOrEqual
  def self.signature
    'min'
  end
end
