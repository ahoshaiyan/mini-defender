# frozen_string_literal: true

require 'action_dispatch'

class MiniDefender::Rules::File < MiniDefender::Rule
  def self.signature
    'file'
  end

  def passes?(attribute, value, validator)
    value.is_a?(ActionDispatch::Http::UploadedFile)
  end

  def message(attribute, value, validator)
    "The field should be a file."
  end
end
