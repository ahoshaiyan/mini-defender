# frozen_string_literal: true

module MiniDefender
  class RulesFactory
    def self.blueprints
      @@blueprints ||= []
    end

    def self.register(klass)
      blueprints << klass
    end

    def init_set(rule_set)
      rule_set = rule_set.split('|') if rule_set.is_a?(String)
      raise ArgumentError, 'Rule set must be a string or an array' unless rule_set.is_a?(Array)

      rule_set.map do |rule|
        unless rule.is_a?(String) || rule.is_a?(Rule)
          raise ArgumentError, 'Rule must be a string or an instance of MiniDefender::Rule'
        end

        rule.is_a?(String) ? init_rule(rule) : rule
      end
    end

    def init_rule(signature)
      @blueprints ||= RulesFactory.blueprints

      signature = signature.split(':')
      blueprint = @blueprints.find { |b| b.available? && b.signature == signature[0] }
      raise ArgumentError, "The rule name #{signature[0]} is invalid or not available" if blueprint.nil?

      blueprint.make(signature[1..].join(':').split(','))
    end
  end
end
