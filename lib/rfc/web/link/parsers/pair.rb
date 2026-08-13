# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a header key/value pair into a record.
        class Pair
          def initialize split_pattern: /(?<target>=)|(?<extended>\*=)/,
                         decoder: Decoder.new,
                         model: Models::Pair
            @split_pattern = split_pattern
            @decoder = decoder
            @model = model
          end

          def call text, root_uri:
            key, delimiter, value = text.split split_pattern
            key.strip!

            attributes = decoder.call value
            value = attributes.delete :value
            value = "#{root_uri}#{value}" if key == "anchor" && value.start_with?("/")
            attributes[:value] = value

            model[key:, delimiter:, **attributes]
          end

          private

          attr_reader :split_pattern, :decoder, :model
        end
      end
    end
  end
end
