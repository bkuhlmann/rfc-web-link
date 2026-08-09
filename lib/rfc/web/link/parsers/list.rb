# frozen_string_literal: true

require "strscan"

module RFC
  module Web
    module Link
      module Parsers
        # Parses header links into a list of records.
        class List
          RELATION_PATTERN = /
            (?<prefix>rel=")  # Prefix.
            .+                # One or more characters.
            \s+?              # One or more spaces, lazy.
            .+                # One or more characters.
            (?<suffix>")      # Suffix.
          /x

          def initialize relation_pattern: RELATION_PATTERN, line: Line.new, list: Models::List.new
            @scanner = StringScanner.new ""
            @relation_pattern = relation_pattern
            @line = line
            @list = list
            @comma = ","
            @quote = %(")
          end

          def call text, root_uri:
            text = String text
            list.clear

            return list unless text.start_with? "<"

            scanner.string = text

            build_list root_uri
          end

          private

          attr_reader :scanner, :relation_pattern, :line, :list, :comma, :quote

          def build_list root_uri, buffer: +"", lines: []
            check scanner.getch, buffer, lines until scanner.eos?

            lines.append(buffer.dup)
                 .each { maybe_split_by_relation it.strip, root_uri: }

            list
          end

          def check character, buffer, lines
            case character
              when quote then enquote buffer
              when comma
                lines.append buffer.dup
                buffer.clear
              else buffer << character
            end
          end

          def enquote buffer
            start = scanner.pos
            scanner.scan_until quote
            buffer << %("#{scanner.pre_match[start..]}")
          end

          # rubocop:todo Metrics/AbcSize
          def maybe_split_by_relation text, root_uri:
            match = text.match relation_pattern

            return list.add line.call(text, root_uri:) unless match

            match.to_s
                 .delete_prefix(match[:prefix])
                 .delete_suffix(match[:suffix])
                 .split
                 .each { list.add line.call(text.sub(relation_pattern, "rel=#{it}"), root_uri:) }
          end
          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
