# spec/genericode/converter_spec.rb

require "spec_helper"
require_relative "../../../lib/genericode/cli/converter"

RSpec.describe Genericode::Cli::Converter do
  describe ".convert" do
    it "converts XML to JSON" do
      allow(File).to receive(:read).and_return("<CodeList></CodeList>")
      allow(File).to receive(:write)
      allow_any_instance_of(Genericode::CodeList).to receive(:to_json).and_return("{}")

      expect(Genericode::Cli::Converter.convert("input.gc", "output.gcj")).to be true
    end

    it "converts JSON to XML" do
      allow(File).to receive(:read).and_return("{}")
      allow(File).to receive(:write)
      allow_any_instance_of(Genericode::CodeList).to receive(:to_xml).and_return("<CodeList></CodeList>")

      expect(Genericode::Cli::Converter.convert("input.gcj", "output.gc")).to be true
    end

    it "raises an error for invalid input format" do
      expect { Genericode::Cli::Converter.convert("input.txt", "output.gcj") }.to raise_error(Genericode::Error, "Invalid input format")
    end

    it "raises an error for invalid output format" do
      expect { Genericode::Cli::Converter.convert("input.gc", "output.txt") }.to raise_error(Genericode::Error, "Invalid output format")
    end

    it "raises an error when input and output formats are the same" do
      expect { Genericode::Cli::Converter.convert("input.gc", "output.gc") }.to raise_error(Genericode::Error, "Input and output formats are the same")
    end
  end
end
