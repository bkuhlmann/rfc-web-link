# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a header line into a link record.
        class Line
          def initialize patterns: PATTERNS, pair: Pair.new, model: Models::Link
            @patterns = patterns
            @pair = pair
            @model = model
          end

          def call text, root_uri:
            link, *parts = text.split delimiter
            pairs = process parts, root_uri

            build_model link, pairs, root_uri
          end

          private

          attr_reader :patterns, :pair, :model

          def instance_variables_to_inspect = %i[@pair @model]

          def process parts,
                      root_uri,
                      default: Hash.new { |nascence, lacuna| nascence[lacuna] = [] }
            parts.each.with_object default do |part, all|
              part = pair.call(part, root_uri:)
              key = part.key

              case part
                in key: "hreflang" then all[key].append part
                in delimiter: "*=" then all[key].clear.append part
                else all[key].append part unless all.key? key
              end
            end
          end

          def build_model link, pairs, root_uri
            model[uri: build_uri(link, root_uri:), pairs: Set[*pairs.values.flatten!]]
          end

          def build_uri value, root_uri:
            value.match(uri_pattern)[:value].then do |uri|
              uri.start_with?("/") ? "#{root_uri}#{uri}" : uri
            end
          end

          def uri_pattern
            @uri_pattern ||= patterns.fetch :uri
          end

          def delimiter
            @delimiter ||= patterns.fetch :line_delimiter
          end
        end
      end
    end
  end
end
