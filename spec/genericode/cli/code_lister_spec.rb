# frozen_string_literal: true

require "spec_helper"
require_relative "../../../lib/genericode/cli/code_lister"

RSpec.describe Genericode::Cli::CodeLister do
  describe ".list_codes" do
    let(:valid_xml) do
      <<~XML
        <CodeList>
          <ColumnSet>
            <Column Id="code">
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

      expect(Genericode::Cli::CodeLister.list_codes("valid.gc")).to eq("Code\nCode1\nCode2")
    end

    it "raises an error when an invalid ColumnRef is found" do
      xml_with_invalid_column_ref = <<~XML
        <CodeList>
          <ColumnSet>
            <Column Id="code">
              <ShortName>Code</ShortName>
            </Column>
          </ColumnSet>
          <SimpleCodeList>
            <Row>
              <Value ColumnRef="invalid">
                <SimpleValue>Code1</SimpleValue>
              </Value>
            </Row>
          </SimpleCodeList>
        </CodeList>
      XML
      allow(File).to receive(:read).and_return(xml_with_invalid_column_ref)
      allow(Genericode::CodeList).to receive(:from_xml).and_call_original

      expect do
        Genericode::Cli::CodeLister.list_codes("invalid.gc")
      end.to raise_error(Genericode::Error,
                         /INVALID_COLUMN_REF: Invalid ColumnRef 'invalid' in row 1/,)
    end

    it "raises an error when a code value is invalid" do
      invalid_xml = <<~XML
        <CodeList>
          <ColumnSet>
            <Column Id="code">
              <ShortName>Code</ShortName>
              <Data Type="integer"/>
            </Column>
          </ColumnSet>
          <SimpleCodeList>
            <Row>
              <Value ColumnRef="code">
                <SimpleValue>Invalid</SimpleValue>
              </Value>
            </Row>
          </SimpleCodeList>
        </CodeList>
      XML
      allow(File).to receive(:read).and_return(invalid_xml)
      allow(Genericode::CodeList).to receive(:from_xml).and_call_original

      expect do
        Genericode::Cli::CodeLister.list_codes("invalid.gc")
      end.to raise_error(Genericode::Error,
                         /INVALID_DATA_TYPE: Invalid data type for column 'Code' in row 1/,)
    end
  end
end
