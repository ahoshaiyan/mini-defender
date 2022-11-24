# frozen_string_literal: true

module MiniDefender::Rules
end

Dir["#{__dir__}/rules/*.rb"].each do |path|
  require_relative path
end
