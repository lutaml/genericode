# frozen_string_literal: true

# spec/genericode/code_lookup_spec.rb

require "spec_helper"
require_relative "../../../lib/genericode/cli/code_lookup"

RSpec.describe Genericode::Cli::CodeLookup do
  describe ".lookup" do
    let(:valid_xml) do
      <<~XML
        <CodeList>
          <ColumnSet>
            <Column Id="code">
              <ShortName>Code</ShortName>
            </Column>
            <Column Id="name">
              <ShortName>Name</ShortName>
            </Column>
          </ColumnSet>
          <SimpleCodeList>
            <Row>
              <Value ColumnRef="code">
                <SimpleValue>Code1</SimpleValue>
              </Value>
              <Value ColumnRef="name">
                <SimpleValue>Name1</SimpleValue>
              </Value>
            </Row>
          </SimpleCodeList>
        </CodeList>
      XML
    end

    before do
      allow(File).to receive(:read).and_return(valid_xml)
      allow(Genericode::CodeList).to receive(:from_xml).and_call_original
    end

    it "looks up a code successfully" do
      expect(Genericode::Cli::CodeLookup.lookup("file.gc", "code:Code1")).to eq("Code: Code1\nName: Name1")
    end

    it "looks up a name successfully" do
      expect(Genericode::Cli::CodeLookup.lookup("file.gc", "name:Name1")).to eq("Code: Code1\nName: Name1")
    end

    it "looks up a simple value successfully" do
      expect(Genericode::Cli::CodeLookup.lookup("file.gc", "code:Code1>name")).to eq("Name1")
    end

    it "raises an error for invalid path" do
      expect do
        Genericode::Cli::CodeLookup.lookup("file.gc",
                                           "invalid:path",)
      end.to raise_error(Genericode::Error, "Column not found: invalid")
    end
  end
end
