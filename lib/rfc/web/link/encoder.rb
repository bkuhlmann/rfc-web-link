# frozen_string_literal: true

module RFC
  module Web
    module Link
      # A HTTP header field encoder which adheres to RFC 8187.
      class Encoder
        def initialize pattern: /[^0-9a-zA-Z!\#$&+\-.^_`|~]/
          @pattern = pattern
        end

        def call(text) = text.match?(pattern) ? convert_characters(text).join : text

        private

        attr_reader :pattern

        def convert_characters text
          text.each_char.map do |character|
            next character unless character.match? pattern

            character.bytes
                     .map { format "%%%02X", it }
                     .join
          end
        end
      end
    end
  end
end
