# frozen_string_literal: true

module MiniDefender
    class Validator
        attr_reader :rules, :data, :errors

        def initialize(rules, data)
            @rules = rules
            @data = data
            @validated = nil
            @coerced = nil
            @errors = nil
            @expander = RulesExpander.new
            @factory = RulesFactory.new
        end

        def validate
            return unless @errors.nil?

            # required, nullable, bail

            @errors = {}
            @validated = {}
            @coerced = {}

            data_rules = @expander.expand(@rules, @data).to_h { |k, set| [k, @factory.init_set(set)] }
            data_rules.each do |k, rule_set|
                value = dig_data(k)
                @errors[k] = []

                rule_set.each do |rule|
                    unless rule.passes?(k, value, self)
                        @errors[k] << rule.message(k, value, self)
                    end
                end

                if @errors[k].empty?
                    @validated[k] = value
                    @coerced[k] = rule_set.inject(value) { |coerced, rule| rule.coerce(coerced) }
                end
            end
        end

        def validate!
            validate if @errors.nil?
            raise ValidationError.new('Data validation failed', @errors) unless @errors.empty?
        end

        def passes?
            validate if @errors.nil?
            @errors.empty?
        end

        def fails?
            !passes?
        end

        def validated
            validate! if @errors.nil?
            @validated
        end

        def coerced
            validate! if @errors.nil?
            @coerced
        end

        private

        def dig_data(key)
            key = key.split('.')
            current = @data

            until key.empty?
                current_key = k.shift
                return [false, nil] if current.is_a?(Hash) && !current.key?(current_key)
                return [false, nil] if current.is_a?(Array) && current_key.to_i >= current.length

                current = current[current_key]
            end

            [true, current]
        end
    end
end
