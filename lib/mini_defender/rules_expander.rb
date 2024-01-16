# frozen_string_literal

module MiniDefender
  class RulesExpander
    # @param [Hash] rules
    # @param [Hash] flat_data
    # @return [Hash]
    def expand(rules, flat_data)
      result = {}

      rules.each do |rule_key, rule_set|
        unless rule_key.include?('*')
          result[rule_key] = rule_set
          next
        end

        k_pattern = Regexp.compile('\A' + rule_key.gsub(/\*/, '\d+') + '\Z')

        flat_data.each do |value_key, _|
          next unless k_pattern.match?(value_key)
          result[value_key] = rule_set
        end
      end

      result
    end
  end
end
