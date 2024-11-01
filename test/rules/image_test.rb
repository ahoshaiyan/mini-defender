# frozen_string_literal: true

require 'test_helper'
require 'tempfile'

module MiniDefender
  module Rules
    class ImageTest < Minitest::Test
      def setup
        @rule = MiniDefender::Rules::Image.new
      end

      def test_signature
        assert_equal 'image', MiniDefender::Rules::Image.signature
      end

      def test_passes_with_valid_jpeg
        file = create_image_file
        assert @rule.passes?(nil, file, nil)
      end

      def test_fails_with_spoofed_content_type
        file = create_file_with_spoofed_content_type
        refute @rule.passes?(nil, file, nil)
      end

      private

      def create_image_file
        tempfile = Tempfile.new(['image', '.jpg'])
        tempfile.write("\xFF\xD8\xFF") # JPEG magic numbers
        tempfile.rewind

        ActionDispatch::Http::UploadedFile.new(
          tempfile: tempfile,
          filename: 'image.jpg',
          type: 'image/jpeg'
        )
      end

      def create_file_with_spoofed_content_type
        tempfile = Tempfile.new(['text', '.jpg'])
        tempfile.write("This is just text")
        tempfile.rewind

        ActionDispatch::Http::UploadedFile.new(
          tempfile: tempfile,
          filename: 'file.exe',
          type: 'image/jpeg'
        )
      end

      def teardown
        ObjectSpace.each_object(Tempfile) do |tempfile|
          tempfile.close!
        end
      end
    end
  end
end
