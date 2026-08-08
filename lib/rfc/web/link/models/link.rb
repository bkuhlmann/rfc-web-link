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

        # Models a link record.
        Link = Data.define(:uri, *KEY_MAP.keys) do
          def initialize uri:,
                         relation:,
                         anchor: nil,
                         language: nil,
                         media: nil,
                         title: nil,
                         type: nil
            super
          end

          # :reek:FeatureEnvy
          def to_s key_map: KEY_MAP
            attributes = to_h.compact
            uri = attributes.delete :uri
            all = attributes.transform_keys!(key_map)
                            .map { |key, value| "#{key}=#{value}" }
                            .join "; "

            "<#{uri}>; #{all}"
          end
        end
      end
    end
  end
end
