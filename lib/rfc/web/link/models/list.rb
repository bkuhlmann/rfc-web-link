# frozen_string_literal: true

require "forwardable"

module RFC
  module Web
    module Link
      module Models
        # Models a list of links.
        List = Data.define :links do
          extend Forwardable
          include Enumerable

          delegate %i[empty? size] => :links

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

          def each
            return enum_for :each unless block_given?

            links.each { yield it }
          end

          def to_s(delimiter: ", ") = links.join delimiter

          alias_method :to_str, :to_s

          private :links
        end
      end
    end
  end
end
