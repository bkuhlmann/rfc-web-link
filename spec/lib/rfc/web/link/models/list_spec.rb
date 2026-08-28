# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Models::List do
  subject(:model) { described_class.new }

  let(:relation) { RFC::Web::Link::Models::Link[uri: "https://test.io"].append :rel, "index" }
  let(:title) { RFC::Web::Link::Models::Link[uri: "https://test.io"].append :title, "Test" }

  describe "#empty?" do
    it "answers true when empty" do
      expect(model.empty?).to be(true)
    end

    it "answers false when filled" do
      model.add relation
      expect(model.empty?).to be(false)
    end
  end

  describe "#size" do
    it "answers zero with no links" do
      expect(model.size).to eq(0)
    end

    it "answers positive integer with links" do
      model.add relation
      expect(model.size).to eq(1)
    end
  end

  describe "#add" do
    it "adds link" do
      model.add relation
      expect(model).to eq(described_class[links: Set[relation]])
    end

    it "ignores duplicates" do
      model.add(relation).add(relation)
      expect(model).to eq(described_class[links: Set[relation]])
    end

    it "answers itself" do
      expect(model.add(relation)).to eq(described_class[links: Set[relation]])
    end
  end

  describe "#clear" do
    it "clears all links" do
      model.add relation
      model.clear

      expect(model.empty?).to be(true)
    end

    it "answers itself" do
      expect(model.clear).to eq(described_class.new)
    end
  end

  describe "#each" do
    it "enumerates over each link" do
      model.add(relation).add title
      buffer = +""

      model.each { buffer << "#{it} " }

      expect(buffer).to eq("<https://test.io>; rel=index <https://test.io>; title=Test ")
    end

    it "answers an enumerator when not given a block" do
      expect(model.each).to be_a(Enumerator)
    end
  end

  shared_examples "a string" do |method|
    it "answers multiple links" do
      model.add(relation).add title

      expect(model.public_send(method)).to eq(
        "<https://test.io>; rel=index, <https://test.io>; title=Test"
      )
    end

    it "answer a single link" do
      model.add relation
      expect(model.public_send(method)).to eq("<https://test.io>; rel=index")
    end

    it "answer an empty string with no links" do
      expect(model.public_send(method)).to eq("")
    end
  end

  describe "#to_s" do
    it_behaves_like "a string", :to_s
  end

  describe "#to_str" do
    it_behaves_like "a string", :to_str
  end
end
