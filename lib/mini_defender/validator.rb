# frozen_string_literal: true

module MiniDefender
    class Validator
        attr_reader :rules, :data, :errors

        def initialize(rules, data)
            @rules = rules
            @data = data
            @errors = nil
            @validated = nil
            @coerced = nil
            @expander = RulesExpander.new
            @factory = RulesFactory.new
            @digger = DataDigger.new
        end

        def validate
            return unless @errors.nil?

            # required, nullable, bail

            @errors = {}
            @validated = {}
            @coerced = {}

            data_rules = @expander.expand(@rules, @data).to_h do |k, set|
                [k, @factory.init_set(set)]
            end

            data_rules.each do |k, rule_set|
                @errors[k] = []

                required = rule_set.any? { |r| r.implicit? }
                found, value = @digger.dig(@data, k)

                unless found
                    @errors[k] << 'The field is missing' if required
                    next
                end

                rule_set.each do |rule|
                    next unless rule.active?(self)

                    unless rule.passes?(k, value, self)
                        @errors[k] << rule.message(k, value, self)
                    end
                end

                if @errors[k].empty?
                    @validated[k] = value
                    @coerced[k] = rule_set.inject(value) { |coerced, rule| rule.coerce(coerced) }
                end
            end

            @errors.reject! { |_, v| v.empty? }
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

        def dig(key)
            @digger.dig(@data, key)
        end
    end
end
