# frozen_string_literal: true

require 'test_helper'
require 'tempfile'

module MiniDefender
  module Rules
    class MimeTypesTest < Minitest::Test
      def setup
        @rule = MiniDefender::Rules::MimeTypes.make(['image/jpeg'])
      end

      def test_signature
        assert_equal 'mime', MiniDefender::Rules::MimeTypes.signature
      end
      def test_passes_with_valid_type
        file = create_file_with_magic_numbers
        assert @rule.passes?(nil, file, nil)
      end

      def test_fails_with_spoofed_content_type
        file = create_text_file_with_spoofed_type
        refute @rule.passes?(nil, file, nil)
      end

      private

      def create_file_with_magic_numbers
        tempfile = Tempfile.new(['test', '.jpg'])
        tempfile.write("\xFF\xD8\xFF") # JPEG magic numbers
        tempfile.rewind

        ActionDispatch::Http::UploadedFile.new(
          tempfile: tempfile,
          filename: 'test.jpg',
          type: 'image/jpeg'
        )
      end

      def create_text_file_with_spoofed_type
        tempfile = Tempfile.new(['test', '.jpg'])
        tempfile.write("This is just text")
        tempfile.rewind

        ActionDispatch::Http::UploadedFile.new(
          tempfile: tempfile,
          filename: 'test.jpg',
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
