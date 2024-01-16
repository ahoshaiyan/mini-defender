# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'mini_defender'

puts 'Loading data...'
data = JSON.parse(
  File.read(__dir__ + '/fixtures/large.json')
)

rules = {
  'company' => 'required|string',

  'address' => 'required|hash',
  'address.line_1' => 'required|string|max:64',
  'address.line_2' => 'required|string|max:64',
  'address.zip' => 'required|string',
  'address.state' => 'required|string|max:30',
  'address.city' => 'required|string|max:30',
  'address.country' => 'required|string',

  'employees' => 'required|array',
  'employees.*' => 'hash',
  'employees.*.name' => 'required|string',
  'employees.*.phone' => 'string',
  'employees.*.job_title' => 'required|string',
  'employees.*.address' => 'required|hash',
  'employees.*.address.line_1' => 'required|string|max:64',
  'employees.*.address.line_2' => 'required|string|max:64',
  'employees.*.address.zip' => 'required|string',
  'employees.*.address.state' => 'required|string|max:30',
  'employees.*.address.city' => 'required|string|max:30',
  'employees.*.address.country' => 'required|string',
  'employees.*.cars' => 'array',
  'employees.*.cars.*' => 'hash',
  'employees.*.cars.*.make' => 'required|string',
  'employees.*.cars.*.model' => 'required|string',
  'employees.*.cars.*.year' => 'integer',
}

validator = MiniDefender::Validator.new(rules, data)

puts 'Validating...'
validator.validate

pp validator.errors

File.write(__dir__ + '/fixtures/large-result.json', JSON.pretty_generate(validator.coerced))