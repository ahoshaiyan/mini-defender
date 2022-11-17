# frozen_string_literal: true

class MiniDefender::Rules::Image < MiniDefender::Rule
  MIMES = %w[image/jpeg image/png image/gif image/bmp image/png image/svg+xml image/webp]

  def self.signature
    'image'
  end

  def passes?(attribute, value, validator)
    value.is_a?(ActionDispatch::Http::UploadedFile) && MIMES.include?(value.content_type)
  end

  def message(attribute, value, validator)
    "The field should be an image of type jpg, jpeg, png, bmp, gif, svg, or webp."
  end
end
