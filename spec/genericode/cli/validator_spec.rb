# spec/genericode/validator_spec.rb

require "spec_helper"
require_relative "../../../lib/genericode/cli/validator"

RSpec.describe Genericode::Cli::Validator do
  describe ".validate" do
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
          </SimpleCodeList>
        </CodeList>
      XML
    end

    it "validates a valid XML file" do
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return(valid_xml)

      expect(Genericode::Cli::Validator.validate("valid.gc")).to be true
    end

    it "raises an error for non-existent file" do
      allow(File).to receive(:exist?).and_return(false)

      expect { Genericode::Cli::Validator.validate("nonexistent.gc") }.to raise_error(Genericode::Error, "File does not exist")
    end

    it "raises an error for invalid file format" do
      allow(File).to receive(:exist?).and_return(true)

      expect { Genericode::Cli::Validator.validate("invalid.txt") }.to raise_error(Genericode::Error, "Invalid file format")
    end

    it "raises an error for empty column set" do
      xml_without_columns = "<CodeList><ColumnSet></ColumnSet><SimpleCodeList><Row></Row></SimpleCodeList></CodeList>"
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return(xml_without_columns)

      expect { Genericode::Cli::Validator.validate("invalid.gc") }.to raise_error(Genericode::Error, "No columns defined")
    end

    it "raises an error for empty row set" do
      xml_without_rows = "<CodeList><ColumnSet><Column></Column></ColumnSet><SimpleCodeList></SimpleCodeList></CodeList>"
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return(xml_without_rows)

      expect { Genericode::Cli::Validator.validate("invalid.gc") }.to raise_error(Genericode::Error, "No rows defined")
    end
  end
end
