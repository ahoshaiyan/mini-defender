# frozen_string_literal: true

module MiniDefender::ValidatesInput
  extend ActiveSupport::Concern

  def validate!(rules, coerced = false)
    data = cleanse_data(params.to_unsafe_hash.deep_stringify_keys)
    validator = MiniDefender::Validator.new(rules, data)
    validator.validate!
    coerced ? validator.coerced : validator.data
  end

  private

  def cleanse_data(data)
    data = data.to_h do |k, v|
      v = v.strip
      v = nil if v.blank?
      [k, v]
    end

    data.compact
  end
end
