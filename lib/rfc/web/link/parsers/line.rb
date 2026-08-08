# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a header line into a link record.
        class Line
          def initialize delimiter: /;\s*?/, pair: Pair.new, model: Models::Link
            @delimiter = delimiter
            @pair = pair
            @model = model
          end

          def call text, root_uri:
            link, *parts = text.split delimiter
            pairs = process parts, root_uri

            build_model link, pairs, root_uri
          end

          private

          attr_reader :delimiter, :pair, :model

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
            value.delete_prefix("<")
                 .delete_suffix(">")
                 .then { it.start_with?("/") ? "#{root_uri}#{it}" : it }
          end
        end
      end
    end
  end
end
