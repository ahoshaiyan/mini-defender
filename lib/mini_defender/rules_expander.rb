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
        k_pattern_result = {}

        flat_data.each do |value_key, _|
          next unless k_pattern.match?(value_key)
          k_pattern_result[value_key] = rule_set
        end

        if k_pattern_result.empty?
          k_pattern_result[k_pattern.source.gsub(/\\[AZ]/, '').gsub('\d+', '0')] = rule_set
        end

        result.merge!(k_pattern_result)
      end

      result
    end

    def array_patterns(rules)
      unless rules.is_a?(Hash)
        raise ArgumentError, 'Rules must be a Hash'
      end

      result = rules.keys.filter { |key| key.include?('*') }

      # If the user hasn't add a rule for each of the array elements, add it manually
      rules.keys.each do |key|
        current = []
        key.split('.').each do |section|
          current << section
          result << current.join('.') if section == '*'
        end
      end

      result.sort.uniq.map { |key| Regexp.compile('\A' + key.gsub(/\*/, '\d+') + '\Z') }
    end
  end
end
