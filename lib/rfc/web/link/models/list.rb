# frozen_string_literal: true

require "forwardable"

module RFC
  module Web
    module Link
      module Models
        # Models a list of links.
        List = Data.define :links do
          extend Forwardable

          delegate %i[all? any? empty? find include? map none? one? size] => :links

          def initialize links: Set.new
            super
          end

          def add line
            links.add line
            self
          end

          def clear
            links.clear
            self
          end

          def each(&block) = block ? links.each(&block) : self

          def reject(&) = with links: Set[*links.reject(&)]

          def select(&) = with links: Set[*links.select(&)]

          def to_s(delimiter: ", ") = links.join delimiter

          alias_method :to_str, :to_s

          private :links
        end
      end
    end
  end
end
