# frozen_string_literal: true

require 'active_support/core_ext/hash'

module MiniDefender::ValidationHelpers
  extend ActiveSupport::Concern

  def validation_errors
    @validation_errors ||= flash[:validation_errors] || {}
  end

  def has_validation_errors?
    validation_errors.length > 0
  end

  def old_values
    @old_values ||= flash[:old_values] || {}
  end

  def old_value(field, default = nil)
    # Transform Rails foo[bar] convention to foo.bar
    field = field.gsub('[', '.').gsub(']', '')
    field = field.split('.')

    result = old_values.deep_stringify_keys

    while (key = field.shift)
      key = key.to_i if Array === result

      if Hash === result[key] || Array === result[key] || field.empty?
        result = result[key]
      end
    end

    result || default
  end

  def field_errors(field)
    # Transform Rails foo[bar] convention to foo.bar
    field = field.gsub('[', '.').gsub(']', '')

    validation_errors[field] || []
  end

  def render_field_errors(field)
    unless block_given?
      raise ArgumentError, 'Expected a block.'
    end

    field_errors(field).each { |e| yield(e) }
  end
end
