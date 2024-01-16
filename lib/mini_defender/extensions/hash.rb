# frozen_string_literal: true

class Hash
  def expand
    expanded = {}

    each do |k, v|
      keys = k.split('.')
      node = expanded

      while keys.length > 1
        next_key = keys.shift
        next_node = (node[next_key] ||= {})

        if next_node.is_a?(Array)
          node[next_key] = next_node = next_node.each_with_index.to_h { |value, index| [index.to_s, value] }
        end

        node = next_node
      end

      node[keys.shift] = v
    end

    expanded.compact_keys
  end

  def compact_keys
    result = to_h do |k, v|
      [k, v.is_a?(Hash) ? v.compact_keys : v]
    end

    if !result.empty? && result.all? { |k, _v| k.match?(/\A\d+\z/) }
      result.values
    else
      result
    end
  end
end
