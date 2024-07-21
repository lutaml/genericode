# spec/genericode/code_list_spec.rb

require "spec_helper"
require_relative "../../lib/genericode/code_list"
require "json"

RSpec.describe Genericode::CodeList do
  let(:valid_column_set) do
    Genericode::ColumnSet.new(
      column: [
        Genericode::Column.new(
          id: "code",
          use: "required",
          short_name: Genericode::ShortName.new(content: "Code"),
          data: Genericode::Data.new(type: "string"),
        ),
        Genericode::Column.new(
          id: "name",
          use: "optional",
          short_name: Genericode::ShortName.new(content: "Name"),
          data: Genericode::Data.new(type: "string"),
        ),
      ],
    )
  end

  let(:valid_simple_code_list) do
    Genericode::SimpleCodeList.new(
      row: [
        Genericode::Row.new(
          value: [
            Genericode::Value.new(column_ref: "code", simple_value: Genericode::SimpleValue.new(content: "CODE1")),
            Genericode::Value.new(column_ref: "name", simple_value: Genericode::SimpleValue.new(content: "Name 1")),
          ],
        ),
        Genericode::Row.new(
          value: [
            Genericode::Value.new(column_ref: "code", simple_value: Genericode::SimpleValue.new(content: "CODE2")),
            Genericode::Value.new(column_ref: "name", simple_value: Genericode::SimpleValue.new(content: "Name 2")),
          ],
        ),
      ],
    )
  end

  let(:valid_code_list) do
    described_class.new(
      column_set: valid_column_set,
      simple_code_list: valid_simple_code_list,
    )
  end

  describe "#valid?" do
    it "returns true for a valid code list" do
      expect(valid_code_list).to be_valid
    end

    it "returns false when column set is missing" do
      invalid_code_list = valid_code_list.dup
      invalid_code_list.column_set = nil
      expect(invalid_code_list).not_to be_valid
    end

    it "returns false when simple code list is missing" do
      invalid_code_list = valid_code_list.dup
      invalid_code_list.simple_code_list = nil
      expect(invalid_code_list).not_to be_valid
    end
  end

  describe "#validate_verbose" do
    it "returns an empty array for a valid code list" do
      expect(valid_code_list.validate_verbose).to be_empty
    end

    it "reports missing column set" do
      invalid_code_list = valid_code_list.dup
      invalid_code_list.column_set = nil
      result = invalid_code_list.validate_verbose
      expect(result).to include(hash_including(code: "MISSING_COLUMN_SET"))
    end

    it "reports missing simple code list" do
      invalid_code_list = valid_code_list.dup
      invalid_code_list.simple_code_list = nil
      result = invalid_code_list.validate_verbose
      expect(result).to include(hash_including(code: "MISSING_SIMPLE_CODE_LIST"))
    end

    it "reports duplicate column IDs" do
      invalid_column_set = valid_column_set.dup
      invalid_column_set.column << Genericode::Column.new(id: "code", short_name: Genericode::ShortName.new(content: "Duplicate"))
      invalid_code_list = valid_code_list.dup
      invalid_code_list.column_set = invalid_column_set
      result = invalid_code_list.validate_verbose
      expect(result).to include(hash_including(code: "DUPLICATE_COLUMN_IDS"))
    end

    it "reports missing Code column" do
      invalid_column_set = Genericode::ColumnSet.new(
        column: [Genericode::Column.new(id: "name", short_name: Genericode::ShortName.new(content: "Name"))],
      )
      invalid_code_list = valid_code_list.dup
      invalid_code_list.column_set = invalid_column_set
      result = invalid_code_list.validate_verbose
      expect(result).to include(hash_including(code: "MISSING_CODE_COLUMN"))
    end

    it "reports duplicate code values" do
      invalid_simple_code_list = valid_simple_code_list.dup
      invalid_simple_code_list.row << Genericode::Row.new(
        value: [Genericode::Value.new(column_ref: "code", simple_value: Genericode::SimpleValue.new(content: "CODE1"))],
      )
      invalid_code_list = valid_code_list.dup
      invalid_code_list.simple_code_list = invalid_simple_code_list
      result = invalid_code_list.validate_verbose
      expect(result).to include(hash_including(code: "DUPLICATE_CODE_VALUES"))
    end

    it "reports missing required values" do
      invalid_simple_code_list = valid_simple_code_list.dup
      invalid_simple_code_list.row << Genericode::Row.new(
        value: [Genericode::Value.new(column_ref: "name", simple_value: Genericode::SimpleValue.new(content: "Name 3"))],
      )
      invalid_code_list = valid_code_list.dup
      invalid_code_list.simple_code_list = invalid_simple_code_list
      result = invalid_code_list.validate_verbose
      expect(result).to include(hash_including(code: "MISSING_REQUIRED_VALUE"))
    end

    it "reports invalid data types" do
      invalid_simple_code_list = valid_simple_code_list.dup
      invalid_simple_code_list.row[0].value[0].simple_value.content = "not an integer"
      invalid_code_list = valid_code_list.dup
      invalid_code_list.column_set.column[0].data.type = "integer"
      invalid_code_list.simple_code_list = invalid_simple_code_list
      result = invalid_code_list.validate_verbose
      expect(result).to include(hash_including(code: "INVALID_DATA_TYPE"))
    end
  end

  # New conversion tests
  describe "conversion between XML and JSON" do
    xml_fixtures_dir = File.join(__dir__, "..", "fixtures", "xml", "standard")
    json_fixtures_dir = File.join(__dir__, "..", "fixtures", "json", "standard")

    Dir.glob(File.join(xml_fixtures_dir, "*.gc")).each do |xml_file|
      base_name = File.basename(xml_file, ".gc")
      json_file = File.join(json_fixtures_dir, "#{base_name}.gcj")

      context "with #{base_name}.{gc,gcj}" do
        xml_content = File.read(xml_file)
        json_content = File.read(json_file)

        xit "converts XML to JSON correctly" do
          code_list = described_class.from_xml(xml_content)
          generated_json = JSON.parse(code_list.to_json)
          expected_json = JSON.parse(json_content)

          expect(generated_json).to eq(expected_json)
        end

        xit "converts JSON to XML correctly" do
          code_list = described_class.from_json(json_content)
          generated_xml = code_list.to_xml
          expected_xml = described_class.from_xml(xml_content).to_xml

          expect(generated_xml).to eq(expected_xml)
        end

        it "provides identical attribute access for XML and JSON" do
          xml_code_list = described_class.from_xml(xml_content)
          json_code_list = described_class.from_json(json_content)

          expect(xml_code_list.identification.short_name.content).to eq(json_code_list.identification.short_name.content)
          expect(xml_code_list.column_set.column.size).to eq(json_code_list.column_set.column.size)
          expect(xml_code_list.simple_code_list.row.size).to eq(json_code_list.simple_code_list.row.size)

          # Add more attribute comparisons as needed
        end
      end
    end
  end
end
