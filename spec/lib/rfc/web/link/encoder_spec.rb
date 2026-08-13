# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Encoder do
  subject(:encoder) { described_class.new }

  describe "#call" do
    it "answers original test when not encodable" do
      text = "test"
      expect(encoder.call(text)).to equal(text)
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

    it "answers ampersand" do
      expect(encoder.call("&")).to eq("&")
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

    it "answers encoded umlaut" do
      expect(encoder.call("letztes Käpitel")).to eq("letztes%20K%C3%A4pitel")
    end

    it "answers encoded special characters" do
      expect(encoder.call("£ and € rates")).to eq("%C2%A3%20and%20%E2%82%AC%20rates")
    end
  end
end
