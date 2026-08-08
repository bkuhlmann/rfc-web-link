# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a raw link into a record.
        # :reek:DataClump
        class Line
          DELIMITERS = {
            primary: ";",
            attribute: /
              (?<standard>=)    # Standard.
              |                 # Or.
              (?<extended>\*=)  # Extended.
            /x
          }.freeze

          # rubocop:todo Metrics/ParameterLists
          def initialize delimiters: DELIMITERS,
                         key_map: Models::KEY_MAP.invert,
                         decoder: Decoder.new,
                         model: Models::Link
            @delimiters = delimiters
            @key_map = key_map
            @decoder = decoder
            @model = model
          end
          # rubocop:enable Metrics/ParameterLists

          def call text, root_uri:
            link, *pairs = text.split delimiters.fetch(:primary)
            model[uri: build_uri(link, root_uri:), **process(pairs, root_uri:)]
          end

          private

          attr_reader :delimiters, :key_map, :decoder, :model

          # :reek:FeatureEnvy
          # :reek:TooManyStatements
          def process pairs, root_uri:
            attributes = build_attributes pairs

            attributes.each do |key, value|
              first_value = value.first

              attributes[key] = case key
                                  when :language then value
                                  when :anchor then build_uri(first_value, root_uri:)
                                  else first_value
                                end
            end

            attributes
          end

          def build_uri value, root_uri:
            value.delete_prefix("<")
                 .delete_suffix(">")
                 .then { it.start_with?("/") ? "#{root_uri}#{it}" : it }
          end

          # :reek:TooManyStatements
          # rubocop:todo Metrics/AbcSize
          def build_attributes pairs,
                               default: Hash.new { |nascence, lacuna| nascence[lacuna] = Set.new }
            pairs.each.with_object default do |pair, all|
              key, delimiter, value = pair.split delimiters.fetch(:attribute)
              key = key_map.fetch key.strip
              value = value.undump if value.start_with? %(")

              unless delimiter == "="
                all.delete key
                value = decoder.call(value).text
              end

              all[key].add value
            end
            # rubocop:enable Metrics/AbcSize
          end
        end
      end
    end
  end
end
