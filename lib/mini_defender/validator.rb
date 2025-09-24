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
      @array_patterns = @expander.array_patterns(rules)
    end

    def validate
      unless @errors.nil?
        return
      end

      @errors = {}

      data_rules = @rules.to_h do |k, set|
        [k, @factory.init_set(set)]
      end

      # Set default values for missing data key compared to rules
      defaults_rules = data_rules.filter { |k, set| set.any? { |r| r.defaults?(self) } }
      defaults_rules.each do |key_pattern, set|
        # If element is not inside an array
        unless key_pattern.match?(/\*/)
          if missing_value?(@data[key_pattern])
            @data[key_pattern] = set.map { |r| r.default_value(self) }.reject(&:nil?).first
          end

          next
        end

        parent, sep, child_key = key_pattern.rpartition('*')
        parent += sep

        # If parent or a sibling exists, add the default value
        pattern = Regexp.new("\\A#{parent.gsub('*', '\d')}\\z")
        additions = {}
        @data.each do |k, _|
          unless k.match?(pattern)
            next
          end

          current_child_key = "#{k}#{child_key}"

          unless missing_value?(@data[current_child_key])
            next
          end

          additions[current_child_key] = set.map { |r| r.default_value(self) }.reject(&:nil?).first
        end

        @data.merge!(additions)
      end

      data_rules = @expander.expand(data_rules, @data)
      data_rules.each do |k, rule_set|
        @errors[k] = []

        value_included = true
        required = rule_set.any? { |r| r.implicit?(self) }

        unless @data.key?(k)
          if required
            @errors[k] << 'This field is missing.'
          end

          next
        end

        value = coerced = @data[k]
        force_coerce = false

        rule_set.each do |rule|
          next unless rule.active?(self)

          value_included &= !rule.excluded?(self)

          if rule.passes?(k, coerced, self)
            coerced = rule.coerce(coerced)
            force_coerce = rule.force_coerce?
          else
            @errors[k] << rule.error_message(k, coerced, self)
          end
        end

        if force_coerce
          value = coerced
        end

        if @errors[k].empty? && value_included
          @validated[k] = value
          @coerced[k] = coerced
        end
      end

      @errors.reject! { |_, v| v.empty? }
    end

    def validate!
      validate if @errors.nil?

      unless @errors.empty?
        raise ValidationError.new('Data validation failed', @errors)
      end
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
      @validated_compacted ||= compact_expanded(@validated)
    end

    def coerced
      validate! if @errors.nil?
      @coerced_compacted = compact_expanded(@coerced)
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

    def compact_expanded(hash)
      expanded = {}

      hash.each do |k, v|
        keys = k.split('.')
        node = expanded

        while keys.length > 1
          next_key = keys.shift
          next_node = (node[next_key] ||= {})

          if next_node.is_a?(Array)
            node[next_key] = next_node = next_node.each_with_index.to_h do |value, index|
              [index.to_s, value]
            end
          end

          node = next_node
        end

        node[keys.shift] = v
      end

      compact_keys(expanded)
    end

    def compact_keys(hash, current_key = '')
      current_key_suffixed = if current_key == ''
        ''
      else
        "#{current_key}."
      end

      result = hash.to_h do |k, v|
        [k, v.is_a?(Hash) ? compact_keys(v, current_key_suffixed + k) : v]
      end

      if result.empty?
        return result
      end

      unless @array_patterns.any? { |p| p.match?("#{current_key_suffixed}#{result.keys.first}") }
        return result
      end

      if result.all? { |k, _v| k.match?(/\A\d+\z/) }
        return result.values
      end

      result
    end

    def missing_value?(value)
      value.nil? ||
        value.is_a?(String) && value.strip.empty? ||
        value.is_a?(Hash) && value.empty? ||
        value.is_a?(Array) && value.empty?
    end
  end
end
