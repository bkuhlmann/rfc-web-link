# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link do
  subject(:parser) { described_class.new "https://test.io" }

  describe ".new" do
    it_behaves_like "a header parser"
  end
end
