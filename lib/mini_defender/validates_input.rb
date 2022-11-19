# frozen_string_literal: true

module MiniDefender::ValidatesInput
  extend ActiveSupport::Concern

  def validate!(rules, coerced = false)
    data = params.to_unsafe_hash.deep_stringify_keys
    validator = MiniDefender::Validator.new(rules, data)
    validator.validate!
    coerced ? validator.coerced : validator.data
  end
end
