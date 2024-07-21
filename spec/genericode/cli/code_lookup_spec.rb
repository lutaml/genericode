# spec/genericode/code_lookup_spec.rb

require "spec_helper"
require_relative "../../../lib/genericode/cli/code_lookup"

RSpec.describe Genericode::Cli::CodeLookup do
  describe ".lookup" do
    let(:valid_xml) do
      <<~XML
        <CodeList>
          <ColumnSet>
            <Column id="code">
              <ShortName>Code</ShortName>
            </Column>
            <Column id="name">
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
      expect(Genericode::Cli::CodeLookup.lookup("file.gc", "column_set/Code")).to be_a(Genericode::Column)
    end

    it "looks up a name successfully" do
      expect(Genericode::Cli::CodeLookup.lookup("file.gc", "column_set/Name")).to be_a(Genericode::Column)
    end

    it "looks up a simple value successfully" do
      expect(Genericode::Cli::CodeLookup.lookup("file.gc", "simple_code_list/0/value/0/simple_value/content")).to eq("Code1")
    end

    it "raises an error for invalid path" do
      expect { Genericode::Cli::CodeLookup.lookup("file.gc", "invalid/path") }.to raise_error(Genericode::Error, "Path not found: invalid")
    end
  end
end
