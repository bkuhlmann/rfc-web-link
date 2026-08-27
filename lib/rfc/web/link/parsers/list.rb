# frozen_string_literal: true

require "strscan"

module RFC
  module Web
    module Link
      module Parsers
        # Parses header links into a list of records.
        class List
          def initialize patterns: PATTERNS, line: Line.new, list: Models::List.new
            @patterns = patterns
            @line = line
            @list = list
            @scanner = StringScanner.new ""
            @comma = ","
            @quote = %(")
          end

          def call text, root_uri:
            match = String(text).match uri_pattern
            list.clear

            return list unless match

            scanner.string = match.string

            build_list root_uri
          end

          private

          attr_reader :patterns, :line, :list, :scanner, :comma, :quote

          def instance_variables_to_inspect = %i[@line @list]

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

          def maybe_split_by_relation text, root_uri:
            match = text.match relation_pattern

            return list.add line.call(text, root_uri:) unless match

            match[:value].split.each do |value|
              list.add line.call(text.sub(relation_pattern, "rel=#{value}"), root_uri:)
            end
          end

          def uri_pattern
            @uri_pattern ||= patterns.fetch :uri
          end

          def relation_pattern
            @relation_pattern ||= patterns.fetch :relation
          end
        end
      end
    end
  end
end
