# frozen_string_literal: true

module RFC
  module Web
    module Link
      module Models
        KEY_MAP = {
          anchor: "anchor",
          language: "hreflang",
          media: "media",
          relation: "rel",
          title: "title",
          type: "type"
        }.freeze

        # Models a link.
        Link = Data.define(:uri, *KEY_MAP.keys, :extensions) do
          def initialize uri:,
                         relation:,
                         anchor: nil,
                         language: nil,
                         media: nil,
                         title: nil,
                         type: nil,
                         extensions: {}
            super
          end

          def add_extension name, value
            extensions[name] = value
            self
          end

          def extension?(name) = extensions.key? name

          def to_h
            {uri:, anchor:, language:, media:, relation:, title:, type:, **extensions}.compact
          end

          def to_s key_map: KEY_MAP
            attributes = to_h.except(:uri).transform_keys!(key_map)
                             .map { |key, value| "#{key}=#{value}" }
                             .join "; "

            "<#{uri}>; #{attributes}"
          end
        end
      end
    end
  end
end
