# frozen_string_literal: true

require "uri"

module RFC
  module Web
    module Link
      # A HTTP header field decoder which adheres to RFC 8187.
      class Decoder
        def initialize delimiter: "'", client: URI
          @delimiter = delimiter
          @client = client
          @quote = %(")
        end

        def call text
          value, encoding, language = parse text

          value = client.decode_uri_component(value)
                        .force_encoding(encoding || Encoding::UTF_8)
                        .encode(Encoding::UTF_8)

          {value:, encoding:, language:}
        rescue ArgumentError, NoMethodError
          {value: nil, encoding:, language:}
        end

        private

        attr_reader :delimiter, :client, :quote

        def parse text
          case String(text).delete_prefix(quote).delete_suffix(quote).split delimiter
            in [value] then [value, nil, nil]
            in [encoding, language, value] then [value, encoding, language]
            else [nil, nil, nil]
          end
        end
      end
    end
  end
end
