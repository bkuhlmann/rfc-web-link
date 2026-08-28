# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Encoder do
  subject(:encoder) { described_class.new }

  describe "#call" do
    it "answers non-strings as strings" do
      value = 123
      expect(encoder.call(value)).to eq("123")
    end

    it "answers original text when not encodable" do
      value = "test"
      expect(encoder.call(value)).to equal(value)
    end

    it "answers original text when given type key" do
      value = "text/plain"
      expect(encoder.call(value, key: "type")).to equal(value)
    end

    it "answers quoted text when characters are allowed but includes spaces" do
      expect(encoder.call("test with spaces")).to eq(%("test with spaces"))
    end

    it "answers numbers" do
      expect(encoder.call((0..9).to_a.join)).to eq("0123456789")
    end

    it "answers lowercase letters" do
      expect(encoder.call(("a".."z").to_a.join)).to eq("abcdefghijklmnopqrstuvwxyz")
    end

    it "answers uppercase letters" do
      expect(encoder.call(("A".."Z").to_a.join)).to eq("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    end

    it "answers bang" do
      expect(encoder.call("!")).to eq("!")
    end

    it "answers pound" do
      expect(encoder.call("#")).to eq("#")
    end

    it "answers dollar sign" do
      expect(encoder.call("$")).to eq("$")
    end

    it "answers percent" do
      expect(encoder.call("%")).to eq("%")
    end

    it "answers ampersand" do
      expect(encoder.call("&")).to eq("&")
    end

    it "answers apostrophe" do
      expect(encoder.call("'")).to eq("'")
    end

    it "answers star" do
      expect(encoder.call("*")).to eq("*")
    end

    it "answers plus" do
      expect(encoder.call("+")).to eq("+")
    end

    it "answers dash" do
      expect(encoder.call("-")).to eq("-")
    end

    it "answers period" do
      expect(encoder.call(".")).to eq(".")
    end

    it "answers carrot" do
      expect(encoder.call("^")).to eq("^")
    end

    it "answers underscore" do
      expect(encoder.call("_")).to eq("_")
    end

    it "answers backtick" do
      expect(encoder.call("`")).to eq("`")
    end

    it "answers pipe" do
      expect(encoder.call("|")).to eq("|")
    end

    it "answers tilda" do
      expect(encoder.call("~")).to eq("~")
    end

    it "answers encoded special characters" do
      expect(encoder.call("Déjà vu with £ and € rates")).to eq(
        "D%C3%A9j%C3%A0%20vu%20with%20%C2%A3%20and%20%E2%82%AC%20rates"
      )
    end
  end
end
