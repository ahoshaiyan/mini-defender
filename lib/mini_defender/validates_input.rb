# frozen_string_literal: true

module MiniDefender::ValidatesInput
  extend ActiveSupport::Concern

  def validate!(rules, coerced = false, translations: nil)
    data = cleanse_data(params.to_unsafe_hash.deep_stringify_keys)
    validator = MiniDefender::Validator.new(rules, data, translations)
    validator.validate!
    coerced ? validator.coerced : validator.data
  end

  private

  def cleanse_data(data, depth = 1)
    return data if depth > 16

    case data
      when Array
        data.map{ |v| cleanse_data(v, depth + 1) }.reject(&:nil?)
      when Hash
        data.to_h{ |k, v| [k, cleanse_data(v, depth + 1)] }.compact
      when String
        data = data.strip
        data = nil if data == ''
        data
      else
        data
    end
  end
end
