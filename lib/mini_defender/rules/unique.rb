# frozen_string_literal: true

class MiniDefender::Rules::Unique < MiniDefender::Rule
  def initialize(model, column)
    raise ArgumentError, 'model name must be a string or ActiveRecord::Base' unless model.is_a?(String)
    raise ArgumentError, 'Column name must be a string' unless column.is_a?(String)

    @model = model.camelcase.constantize
    @column = column
    @ignore = nil
  end

  def self.signature
    'unique'
  end

  def should_ignore(value)
    @ignore = value
    self
  end

  def self.make(args)
    raise ArgumentError, 'Model and column are required.' unless args.length == 2

    new(args[0], args[1])
  end

  def passes?(_attribute, value, _validator)
    query = @model.where(@column => value)
    query = query.where.not(@column, @ignore) unless @ignore.nil?
    query.exists?
  end

  def message(_attribute, _value, _validator)
    'The value already exists.'
  end
end
