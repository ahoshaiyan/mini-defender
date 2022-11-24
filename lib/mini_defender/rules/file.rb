# frozen_string_literal: true

require 'action_dispatch'

class MiniDefender::Rules::File < MiniDefender::Rule
  def self.signature
    'file'
  end

  def passes?(_attribute, value, _validator)
    value.is_a?(ActionDispatch::Http::UploadedFile)
  end

  def message(_attribute, _value, _validator)
    'The field should be a file.'
  end
end
