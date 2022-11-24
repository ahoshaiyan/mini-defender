# frozen_string_literal: true

require 'action_dispatch'

class MiniDefender::Rules::MimeTypes < MiniDefender::Rule
  def initialize(types)
    raise ArgumentError, 'Expected an array of strings.' unless types.is_a?(Array) && types.all? { |t| t.is_a?(String) }

    @types = types
    @file = false
  end

  def self.signature
    'mime'
  end

  def self.make(args)
    raise ArgumentError, 'Expected at least one MIME type.' unless args.length > 0

    new(args.split(',').map(&:downcase).map(&:strip))
  end

  def passes?(_attribute, value, _validator)
    @file = value.is_a?(ActionDispatch::Http::UploadedFile)
    @file && @types.include?(@file.content_type)
  end

  def message(_attribute, _value, _validator)
    if @file
      "The file should be one of the following types #{@types.to_sentence}"
    else
      'The field should be a file.'
    end
  end
end
