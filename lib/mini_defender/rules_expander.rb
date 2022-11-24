# frozen_string_literal

module MiniDefender
  class RulesExpander
    # @param [Hash] rules
    # @param [Hash] flat_data
    # @return [Hash]
    def expand(rules, flat_data)
      rules
        .map { |k, v| [Regexp.compile('\A' + k.gsub(/\*/, '\d+') + '\Z'), v] }.to_h
        .map do |p, set|
          data_rules = flat_data.filter { |k, _| p.match? k }.map { |k, _| [k, set] }
          data_rules.length > 0 ? data_rules : [[p.source.gsub(/\\[AZ]/, '').gsub('\d+', '0'), set]]
        end
        .flatten(1)
        .to_h
    end
  end
end
