# frozen_string_literal: true

require "forwardable"

module RFC
  module Web
    module Link
      module Models
        # Models a link.
        Link = Data.define :uri, :pairs do
          extend Forwardable

          delegate %i[empty? include?] => :pairs

          def initialize uri:, pairs: Set.new
            super
          end

          def add pair
            pairs.add pair
            self
          end

          def append key, value, **attributes
            pairs.add Pair[key:, value:, **attributes]
            self
          end

          def find_pair **attributes
            pairs.find do |pair|
              attributes.all? { |key, value| pair.public_send(key).match? value }
            end
          end

          def pair? **attributes
            pairs.any? do |pair|
              attributes.all? { |key, value| pair.public_send(key).match? value }
            end
          end

          def to_s(delimiter: "; ") = "<#{uri}>; #{pairs.join delimiter}"

          alias_method :to_str, :to_s
        end
      end
    end
  end
end
