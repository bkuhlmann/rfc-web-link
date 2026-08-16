# frozen_string_literal: true

require "rfc/web/link/decoder"
require "rfc/web/link/encoder"
require "rfc/web/link/models/link"
require "rfc/web/link/models/list"
require "rfc/web/link/models/pair"
require "rfc/web/link/parsers/header"
require "rfc/web/link/parsers/line"
require "rfc/web/link/parsers/list"
require "rfc/web/link/parsers/pair"

module RFC
  module Web
    # Main namespace.
    module Link
      def self.new(**) = Parsers::Header.new(**)
    end
  end
end
