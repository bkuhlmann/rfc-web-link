# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        PATTERNS = {
          uri: /
            <                 # Prefix.
            (?<value>.+)      # Value named group.
            >                 # Suffix.
          /x,
          relation: /
            rel="             # Prefix.
            (?<value>.+)      # Value named group.
            "                 # Suffix.
          /x,
          line_delimiter: /
            ;                 # Semicolon.
            \s*?              # Optional spaces, lazy.
          /x,
          pair_delimiter: /
            (?<target>=)      # Target named group.
            |                 # Or.
            (?<extended>\*=)  # Extended named group.
          /x
        }.freeze
      end
    end
  end
end
