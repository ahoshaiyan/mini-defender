# frozen_string_literal: true

class MiniDefender::Rules::Unique < MiniDefender::Rule
  def initialize(model, column = nil)
    unless model.is_a?(String) || model.is_a?(Class) && model.ancestors.include?(ActiveRecord::Base)
      raise ArgumentError, 'model name must be a string or ActiveRecord::Base'
    end

    raise ArgumentError, 'Column name must be a string' unless column.is_a?(String) || column.nil?

    @model = model
    @model = @model.camelcase.constantize if model.is_a?(String)
    @column = column
    @ignore = nil
    @additional_scope = nil
  end

  def self.signature
    'unique'
  end

  def should_ignore(value)
    @ignore = value
    self
  end

  def scope_by(callback)
    @additional_scope = callback
    self
  end

  def self.make(args)
    raise ArgumentError, 'Model and column are required.' unless args.length == 2

    self.new(args[0], args[1])
  end

  def passes?(attribute, value, validator)
    @column = attribute.split('.')[-1] if @column.nil?

    query = @model.where(@column => value)
    query = @additional_scope.call(query) unless @additional_scope.nil?
    query = query.where.not(@column, @ignore) unless @ignore.nil?

    !query.exists?
  end

  def message(attribute, value, validator)
    "The value already exists."
  end
end
