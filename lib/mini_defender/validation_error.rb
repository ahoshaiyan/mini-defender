# frozen_string_literal: true

class MiniDefender::ValidationError < StandardError
  attr_reader :errors

  def initialize(msg, errors = {})
    super(msg)
    @errors = errors
  end
end
