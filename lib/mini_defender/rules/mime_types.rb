# frozen_string_literal: true

require 'action_dispatch'
require 'marcel'

class MiniDefender::Rules::MimeTypes < MiniDefender::Rule
  def initialize(types)
    unless types.is_a?(Array) && types.all?{ |t| t.is_a?(String) }
      raise ArgumentError, 'Expected an array of strings.'
    end

    @types = types
    @file = false
  end

  def self.signature
    'mime'
  end

  def self.make(args)
    unless args.length > 0
      raise ArgumentError, 'Expected at least one MIME type.'
    end

    new(args.map(&:downcase).map(&:strip))
  end

  def passes?(attribute, value, validator)
    @file = value.is_a?(ActionDispatch::Http::UploadedFile)
    content_type = Marcel::MimeType.for(value.read)
    value.rewind

    @file && @types.include?(content_type)
  end

  def message(attribute, value, validator)
    if @file
      "The file should be one of the following types #{@types.to_sentence}"
    else
      'The field should be a file.'
    end
  end
end
