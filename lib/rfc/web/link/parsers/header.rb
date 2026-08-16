# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Parsers
        # Parses a header link into a list of records.
        class Header
          def initialize pattern: /link/i, list: List.new
            @pattern = pattern
            @list = list
          end

          def call headers, root_uri:
            text = headers.find { |key, value| break value if key.match? pattern }
            list.call text, root_uri:
          end

          private

          attr_reader :pattern, :list
        end
      end
    end
  end
end
