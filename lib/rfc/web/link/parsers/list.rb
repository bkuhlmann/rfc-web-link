# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a raw link into a record.
        # :reek:DataClump
        class List
          RELATION_PATTERN = /
            (?<prefix>rel=")  # Prefix.
            .+                # One or more characters.
            \s+?              # One or more spaces, lazy.
            .+                # One or more characters.
            (?<suffix>")      # Suffix.
          /x

          def initialize delimiter: ",", relation_pattern: RELATION_PATTERN, line: Line.new
            @delimiter = delimiter
            @relation_pattern = relation_pattern
            @line = line
          end

          def call text, root_uri:
            String(text).split(delimiter)
                        .flat_map { conditionally_split_by_relation it.strip, root_uri: }
          end

          private

          attr_reader :delimiter, :relation_pattern, :line

          def conditionally_split_by_relation text, root_uri:
            match = text.match relation_pattern
            match ? build_relations(text, match, root_uri:) : line.call(text, root_uri:)
          end

          def build_relations text, match, root_uri:
            prefix = match[:prefix]
            suffix = match[:suffix]

            match.to_s
                 .delete_prefix(prefix)
                 .delete_suffix(suffix)
                 .split
                 .map { line.call text.sub(relation_pattern, "#{prefix}#{it}#{suffix}"), root_uri: }
          end
        end
      end
    end
  end
end
