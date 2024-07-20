# frozen_string_literal: true

require "spec_helper"
require "pathname"

RSpec.describe Genericode do
  fixtures_dir = Pathname.new(__dir__).join("fixtures")
  xml_files = Dir[fixtures_dir.join("xml", "*.gc")]
  json_files = Dir[fixtures_dir.join("json", "*.gcj")]

  describe "XML round-trip conversion" do
    xml_files.each do |file_path|
      context "with file #{File.basename(file_path)}" do
        let(:xml_string) { File.read(file_path) }

        it "performs a round-trip conversion" do
          parsed = Genericode::CodeList.from_xml(xml_string)

          generated = parsed.to_xml(
            pretty: true,
            declaration: true,
            encoding: "utf-8",
          )

          expect(generated).to be_analogous_with(xml_string)

          reparsed = Genericode::CodeList.from_xml(generated)

          expect(reparsed.identification.short_name.content).to eq(parsed.identification.short_name.content)
          expect(reparsed.column_set.column.size).to eq(parsed.column_set.column.size)
          expect(reparsed.simple_code_list.row.size).to eq(parsed.simple_code_list.row.size)
        end
      end
    end
  end

  describe "JSON round-trip conversion" do
    json_files.each do |file_path|
      context "with file #{File.basename(file_path)}" do
        let(:json_string) { File.read(file_path) }

        it "performs a round-trip conversion" do
          parsed = Genericode::CodeList.from_json(json_string)
          generated = Genericode::CodeList.to_json(parsed)
          reparsed = Genericode::CodeList.from_json(generated)

          original_to_test = JSON.parse(json_string).to_json
          reparsed_to_test = JSON.parse(reparsed.to_json).to_json

          expect(reparsed.identification.short_name.content).to eq(parsed.identification.short_name.content)
          expect(reparsed.column_set.column.size).to eq(parsed.column_set.column.size)
          expect(reparsed.simple_code_list.row.size).to eq(parsed.simple_code_list.row.size)

          expect(reparsed_to_test).to eq(original_to_test)
        end
      end
    end
  end
end
