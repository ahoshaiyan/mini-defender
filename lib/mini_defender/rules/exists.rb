# frozen_string_literal: true

class MiniDefender::Rules::Exists < MiniDefender::Rule
  def initialize(model, column)
    raise ArgumentError, 'model name must be a string or ActiveRecord::Base' unless model.is_a?(String)
    raise ArgumentError, 'Column name must be a string' unless column.is_a?(String)

    @model = model.camelcase.constantize
    @column = column
  end

  def self.available?
    ! defined?(ActiveRecord).nil?
  end

  def self.signature
    'exists'
  end

  def self.make(args)
    raise ArgumentError, 'Model and column are required.' unless args.length == 2

    self.new(args[0], args[1])
  end

  def passes?(attribute, value, validator)
    @model.where(@column => value).exists?
  end

  def message(attribute, value, validator)
    "The value does not exists."
  end
end
