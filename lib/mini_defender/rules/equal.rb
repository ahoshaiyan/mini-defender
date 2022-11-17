# frozen_string_literal: true

require_relative 'size'

class MiniDefender::Rules::Equal < MiniDefender::Rules::Size
  def self.signature
    'equal'
  end
end
