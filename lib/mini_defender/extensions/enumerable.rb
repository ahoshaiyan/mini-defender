# frozen_string_literal: true

module Enumerable
  def flatten_keys(keep_roots: false)
    flatten_keys_recurse(self, keep_roots: keep_roots)
  end

  private

  def flatten_keys_recurse(root, keep_roots: false)
    return {} unless root.is_a?(Enumerable)

    root = root.each_with_index.to_h { |v, k| [k, v] } unless root.is_a?(Hash)

    result = {}
    root.each do |k, v|
      result[k] = v if keep_roots

      if v.is_a?(Enumerable)
        flatten_keys_recurse(v, keep_roots: keep_roots).each do |sub_key, sub_v|
          result["#{k}.#{sub_key}"] = sub_v
        end
      else
        result[k] = v
      end
    end

    result
  end
end
