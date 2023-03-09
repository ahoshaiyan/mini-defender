# frozen_string_literal: true

module MiniDefender
  class Validator
    attr_reader :rules, :data, :errors

    def initialize(rules, data)
      @rules = rules
      @data = data.flatten_keys(keep_roots: true)
      @errors = nil
      @validated = {}
      @coerced = {}
      @expander = RulesExpander.new
      @factory = RulesFactory.new
    end

    def validate
      return unless @errors.nil?

      @errors = {}

      data_rules = @rules.to_h do |k, set|
        [k, @factory.init_set(set)]
      end

      data_rules.each do |k, set|
        if !@data.key?(k) || @data[k].blank?
          set.filter{ |r| r.defaults?(self) }.each do |r|
            @data.merge!({k => r.default_value(self)}.flatten_keys(keep_roots: true))
          end
        end
      end

      data_rules = @expander.expand(data_rules, @data)

      data_rules.each do |k, rule_set|
        @errors[k] = []

        value_included = true
        required = rule_set.any? { |r| r.implicit?(self) }

        if !@data.key?(k) || @data[k].blank?
          rule_set.filter{ |r| r.defaults?(self) }.each do |r|
            @data.merge!({k => r.default_value(self)}.flatten_keys(keep_roots: true))
          end
        end

        unless @data.key?(k)
          @errors[k] << 'This field is missing.' if required
          next
        end

        value = coerced = @data[k]
        rule_set.each do |rule|
          next unless rule.active?(self)

          value_included &= !rule.excluded?(self)

          if rule.passes?(k, coerced, self)
            coerced = rule.coerce(coerced)
          else
            @errors[k] << rule.error_message(k, value, self)
          end
        end

        if @errors[k].empty? && value_included
          @validated[k] = value
          @coerced[k] = coerced
        end
      end

      @validated = @validated.expand
      @coerced = @coerced.expand

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

    # @return [Hash]
    def neighbors(key, level = 1)
      pattern = leveled_search_pattern(key, level)
      @data.filter { |k, _| k.match?(pattern) }
    end

    # @return [Array]
    def neighbor_values(key, level = 1)
      neighbors(key, level).values
    end

    private

    def leveled_search_pattern(key, level = 1)
      search_key = key.split('.').map{ |part| Regexp.quote(part) }.reverse

      # Change array indexes to digits pattern according to the desired level
      while level > 0
        target_index = search_key.index { |p| p.match?(/\A\d+\z/) }
        break if target_index.nil?
        search_key[target_index] = '\d+'
        level -= 1
      end

      Regexp.compile("\\A#{search_key.reverse.join('\.')}\\z")
    end
  end
end
