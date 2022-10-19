# frozen_string_literal

module MiniDefender
  class RulesExpander
    # @param [Hash] rules
    # @param [Hash] data
    # @return [Hash]
    def expand(rules, data)
      data_flat = flatten_data(data)
      rules
        .map{ |k, v| [Regexp.compile('\A' + k.gsub(/\*/, '\d+') + '\Z'), v] }.to_h
        .map { |p, set|
          data_rules = data_flat.filter { |k, _| p.match? k }.map { |k, _| [k, set] }
          data_rules.length > 0 ? data_rules : [[p.source.gsub(/\\[AZ]/, '').gsub('\d+', '0'), set]]
        }
        .flatten(1)
        .to_h
    end

    def flatten_data(data)
      result = {}
      return result unless data.is_a?(Enumerable)

      unless data.is_a?(Hash)
        data = data.each_with_index.to_h { |v, k| [k, v] }
      end

      data.each do |k, v|
        result[k] = v
        if v.is_a?(Enumerable)
          flatten_data(v).each { |sub_key, sub_v| result["#{k}.#{sub_key}"] = sub_v }
        end
      end

      result
    end
  end
end
