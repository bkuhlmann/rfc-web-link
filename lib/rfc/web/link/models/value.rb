# frozen_string_literal: true

require "uri"

module RFC
  module Web
    module Link
      module Models
        # Models a link value.
        Value = Data.define :text, :encoding, :language do
          def initialize text:, encoding: "UTF-8", language: "en"
            super
          end

          def encode client: URI
            "#{encoding}'#{language}'#{client.encode_uri_component text.encode(encoding)}"
          end
        end
      end
    end
  end
end
