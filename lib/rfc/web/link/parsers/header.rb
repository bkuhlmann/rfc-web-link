# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a header link into a list of records.
        class Header
          def initialize root_uri = nil, pattern: /link/i, list: List.new
            @root_uri = root_uri
            @pattern = pattern
            @list = list
          end

          def call headers, root_uri: nil
            text = headers.find { |key, value| break value if key.match? pattern }
            list.call text, root_uri: root_uri || self.root_uri
          end

          private

          attr_reader :root_uri, :pattern, :list
        end
      end
    end
  end
end
