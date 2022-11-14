# frozen_string_literal: true

class Hash
  def expand
    expanded = {}

    reject{ |_, v| v.is_a?(Hash) || v.is_a?(Array) }.each do |k, v|
      keys = k.split('.')
      node = expanded
      node = (node[keys.shift] ||= {}) while keys.length > 1
      node[keys.shift] = v
    end

    expanded.compact_keys
  end

  def compact_keys
    result = to_h do |k, v|
      [k, v.is_a?(Hash) ? v.compact_keys : v]
    end

    if result.all? { |k, _v| k.match?(/\A\d+\z/) }
      result.values
    else
      result
    end
  end
end
