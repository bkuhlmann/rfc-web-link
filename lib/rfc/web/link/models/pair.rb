# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Models
        # Models the key, delimiter, and decoded value associated with a link.
        Pair = Data.define :key, :delimiter, :value, :encoding, :language do
          def initialize key:, value:, delimiter: "=", encoding: nil, language: nil
            super key: key.to_s, value:, delimiter:, encoding:, language:
          end

          def encoded? = delimiter == "*="

          def to_s encoder: Encoder.new
            if encoding
              "#{key}#{delimiter}#{encoding}'#{language}'" \
              "#{encoder.call value.encode(encoding)}"
            else
              "#{key}#{delimiter}#{encoder.call value, key:}"
            end
          end

          alias_method :to_str, :to_s
        end
      end
    end
  end
end
