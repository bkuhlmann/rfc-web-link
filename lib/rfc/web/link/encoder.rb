# frozen_string_literal: true

module RFC
  module Web
    module Link
      # A HTTP header value encoder which adheres to RFC 8187.
      class Encoder
        def initialize ignored_characters: /\A[0-9a-zA-Z!\#$%&'*+\-.^_`|~]*\z/,
                       ignored_keys: %w[type]
          @ignored_characters = ignored_characters
          @ignored_keys = ignored_keys
        end

        def call value, key: nil
          text = String value

          if text.match?(ignored_characters) || ignored_keys.include?(key) then text
          elsif text.match? ignored_characters_and_spaces then text.dump
          else convert_characters(text).join
          end
        end

        private

        attr_reader :ignored_characters, :ignored_keys

        def convert_characters text
          text.each_char.map do |character|
            next character if character.match? ignored_characters

            character.bytes
                     .map { format "%%%02X", it }
                     .join
          end
        end

        def ignored_characters_and_spaces
          @ignored_characters_and_spaces ||= Regexp.new ignored_characters.source.sub("]", "\\s]")
        end
      end
    end
  end
end
