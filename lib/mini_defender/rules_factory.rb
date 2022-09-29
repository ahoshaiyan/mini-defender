# frozen_string_literal: true

module MiniDefender
  class RulesFactory
    def init_set(rule_set)
      rule_set = rule_set.split('|') if rule_set.is_a?(String)
      raise ArgumentError, 'Rule set must be a string or an array' unless rule_set.is_a?(Array)

      set = rule_set.map do |rule|
        unless rule.is_a?(String) || rule.is_a?(Rule)
          raise ArgumentError, 'Rule must be a string or an instance of MiniDefender::Rule'
        end

        rule.is_a?(String) ? init_rule(rule) : rule
      end

      set
    end

    def init_rule(signature)
      @blueprints ||= fetch_blueprints
      signature = signature.split(':')
      blueprint = @blueprints.find { |b| b.signature == signature[0] }
      raise ArgumentError, "The rule name #{signature[0]} is invalid" if blueprint.nil?

      blueprint.make(signature[1..].join(':').split(','))
    end

    private

    # @return [Array]
    def fetch_blueprints
      MiniDefender::Rules
        .constants
        .map { |id| MiniDefender::Rules.const_get(id) }
        .filter { |const_obj| const_obj.is_a?(Class) && const_obj.superclass == MiniDefender::Rule }
    end
  end
end
