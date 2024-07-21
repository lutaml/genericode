# spec/genericode/cli_spec.rb

require "spec_helper"
require_relative "../../../lib/genericode/cli/commands"

RSpec.describe Genericode::Cli::Commands do
  let(:cli) { described_class.new }

  describe "#convert" do
    it "converts XML to JSON successfully" do
      allow(Genericode::Cli::Converter).to receive(:convert).and_return(true)
      expect { cli.convert("input.gc", "output.gcj") }.to output("Conversion successful.\n").to_stdout
    end

    it "handles conversion errors" do
      allow(Genericode::Cli::Converter).to receive(:convert).and_raise(Genericode::Error, "Conversion failed")
      expect { cli.convert("input.gc", "output.gcj") }.to output("Conversion failed: Conversion failed\n").to_stdout
    end
  end

  describe "#validate" do
    it "validates a file successfully" do
      allow(Genericode::CodeList).to receive(:from_file).and_return(double(valid?: true))
      expect { cli.validate("file.gc") }.to output("File is valid.\n").to_stdout
    end

    it "handles validation errors" do
      allow(Genericode::CodeList).to receive(:from_file).and_raise(Genericode::Error, "Invalid file")
      expect { cli.validate("file.gc") }.to output("Validation failed: Invalid file\n").to_stdout
    end
  end

  describe "#list_codes" do
    it "lists codes successfully" do
      allow(Genericode::Cli::CodeLister).to receive(:list_codes).and_return(["Code1", "Code2"])
      expect { cli.list_codes("file.gc") }.to output("Code1\nCode2\n").to_stdout
    end

    it "handles listing errors" do
      allow(Genericode::Cli::CodeLister).to receive(:list_codes).and_raise(Genericode::Error, "Listing failed")
      expect { cli.list_codes("file.gc") }.to output("Listing codes failed: Listing failed\n").to_stdout
    end
  end

  describe "#lookup" do
    it "looks up a code successfully" do
      allow(Genericode::Cli::CodeLookup).to receive(:lookup).and_return("Result")
      expect { cli.lookup("file.gc", "path") }.to output("Result\n").to_stdout
    end

    it "handles lookup errors" do
      allow(Genericode::Cli::CodeLookup).to receive(:lookup).and_raise(Genericode::Error, "Lookup failed")
      expect { cli.lookup("file.gc", "path") }.to output("Lookup failed: Lookup failed\n").to_stdout
    end
  end
end
