# frozen_string_literal: true

require_relative 'mini_defender/version'
require_relative 'mini_defender/validator'
require_relative 'mini_defender/rule'
require_relative 'mini_defender/rules'
require_relative 'mini_defender/rules_expander'
require_relative 'mini_defender/rules_factory'
require_relative 'mini_defender/validation_error'
require_relative 'mini_defender/validates_input'

# Extensions to Ruby Core
require_relative 'mini_defender/extensions/enumerable'
require_relative 'mini_defender/extensions/hash'

module MiniDefender
end

# Register Library Rules
MiniDefender::Rules.constants
  .map    { |id| MiniDefender::Rules.const_get(id) }
  .filter { |const| const.ancestors.include?(MiniDefender::Rule) }
  .filter { |const| const.available? }
  .each   { |klass| MiniDefender::RulesFactory.register(klass) }
