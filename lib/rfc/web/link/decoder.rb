# frozen_string_literal: true

require "uri"

module RFC
  module Web
    module Link
      # A HTTP header field decoder which adheres to RFC 8187.
      class Decoder
        def initialize delimiter: "'", default_encoding: Encoding::UTF_8, client: URI
          @delimiter = delimiter
          @default_encoding = default_encoding
          @client = client
        end

        def call text
          value, encoding, language = parse text

          value = client.decode_uri_component(value)
                        .force_encoding(encoding || default_encoding)
                        .encode(default_encoding)

          {value:, encoding:, language:}
        rescue ArgumentError, NoMethodError
          {value: nil, encoding:, language:}
        end

        private

        attr_reader :delimiter, :default_encoding, :client

        def parse text
          case String(text).split delimiter
            in [value] then [value, nil, nil]
            in [encoding, language, value] then [value, encoding, language]
            else [nil, nil, nil]
          end
        end
      end
    end
  end
end
