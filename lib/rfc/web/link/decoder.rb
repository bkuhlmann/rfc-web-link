# frozen_string_literal: true

require "uri"

module RFC
  module Web
    module Link
      # A HTTP header field decoder which adheres to RFC 8187.
      class Decoder
        def initialize delimiter: "'", maximum: 3, client: URI
          @delimiter = delimiter
          @maximum = maximum
          @client = client
        end

        def call text, model: Models::Value
          encoding, language, value = text.split delimiter, maximum
          content = client.decode_www_form_component(value).force_encoding(encoding)

          model[text: content.encode(Encoding::UTF_8), encoding:, language:]
        end

        private

        attr_reader :delimiter, :maximum, :client
      end
    end
  end
end
