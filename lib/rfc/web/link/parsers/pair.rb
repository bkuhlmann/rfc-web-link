# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a header key/value pair into a record.
        class Pair
          def initialize patterns: PATTERNS, decoder: Decoder.new, model: Models::Pair
            @patterns = patterns
            @decoder = decoder
            @model = model
          end

          def call text, root_uri:
            key, delimiter, value = text.split delimiter_pattern
            key.strip!

            attributes = decoder.call value
            value = attributes.delete :value
            value = "#{root_uri}#{value}" if key == "anchor" && value.start_with?("/")
            attributes[:value] = value

            model[key:, delimiter:, **attributes]
          end

          private

          attr_reader :patterns, :decoder, :model

          def instance_variables_to_inspect = %i[@decoder @model]

          def delimiter_pattern
            @delimiter_pattern ||= patterns.fetch :pair_delimiter
          end
        end
      end
    end
  end
end
