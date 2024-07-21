# spec/genericode/code_lister_spec.rb

require "spec_helper"
require_relative "../../../lib/genericode/cli/code_lister"

RSpec.describe Genericode::Cli::CodeLister do
  describe ".list_codes" do
    let(:valid_xml) do
      <<~XML
        <CodeList>
          <ColumnSet>
            <Column id="code">
              <ShortName>Code</ShortName>
            </Column>
          </ColumnSet>
          <SimpleCodeList>
            <Row>
              <Value ColumnRef="code">
                <SimpleValue>Code1</SimpleValue>
              </Value>
            </Row>
            <Row>
              <Value ColumnRef="code">
                <SimpleValue>Code2</SimpleValue>
              </Value>
            </Row>
          </SimpleCodeList>
        </CodeList>
      XML
    end

    it "lists codes from a valid XML file" do
      allow(File).to receive(:read).and_return(valid_xml)
      allow(Genericode::CodeList).to receive(:from_xml).and_call_original

      expect(Genericode::Cli::CodeLister.list_codes("valid.gc")).to eq(["Code1", "Code2"])
    end

    it "raises an error when no Code column is found" do
      xml_without_code_column = '<CodeList><ColumnSet><Column id="other"><ShortName>Other</ShortName></Column></ColumnSet><SimpleCodeList></SimpleCodeList></CodeList>'
      allow(File).to receive(:read).and_return(xml_without_code_column)
      allow(Genericode::CodeList).to receive(:from_xml).and_call_original

      expect { Genericode::Cli::CodeLister.list_codes("invalid.gc") }.to raise_error(Genericode::Error, "No 'Code' column found")
    end

    it "raises an error when a code value is invalid" do
      invalid_xml = <<~XML
        <CodeList>
          <ColumnSet>
            <Column id="code">
              <ShortName>Code</ShortName>
            </Column>
          </ColumnSet>
          <SimpleCodeList>
            <Row>
              <Value ColumnRef="code">
                <ComplexValue>Invalid</ComplexValue>
              </Value>
            </Row>
          </SimpleCodeList>
        </CodeList>
      XML
      allow(File).to receive(:read).and_return(invalid_xml)
      allow(Genericode::CodeList).to receive(:from_xml).and_call_original

      expect { Genericode::Cli::CodeLister.list_codes("invalid.gc") }.to raise_error(Genericode::Error, /Invalid code value for row/)
    end
  end
end
