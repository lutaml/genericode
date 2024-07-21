# frozen_string_literal: true

require "spec_helper"
require "pathname"
require_relative "../lib/genericode/code_list"

RSpec.describe Genericode do
  fixtures_dir = Pathname.new(__dir__).join("fixtures")

  def check_parsed_content(parsed, reparsed)
    expect(reparsed.identification.short_name.content).to eq(parsed.identification.short_name.content)
    expect(reparsed.column_set.column.size).to eq(parsed.column_set.column.size)
    expect(reparsed.simple_code_list.row.size).to eq(parsed.simple_code_list.row.size)
  end

  describe "XML round-trip conversion" do
    xml_files = Dir[fixtures_dir.join("xml", "*", "*.gc")]

    xml_files.each do |file_path|
      context "with file #{Pathname.new(file_path).relative_path_from(fixtures_dir)}" do
        let(:xml_string) { File.read(file_path) }

        it "provides identical attribute access" do
          parsed = Genericode::CodeList.from_xml(xml_string)
          generated = parsed.to_xml(
            pretty: true,
            declaration: true,
            encoding: "utf-8",
          )
          reparsed = Genericode::CodeList.from_xml(generated)

          check_parsed_content(parsed, reparsed)
        end

        it "performs lossless round-trip conversion" do
          parsed = Genericode::CodeList.from_xml(xml_string)
          generated = parsed.to_xml(
            pretty: true,
            declaration: true,
            encoding: "utf-8",
          )

          expect(generated).to be_analogous_with(xml_string)
        end
      end
    end
  end

  describe "JSON round-trip conversion" do
    json_files = Dir[fixtures_dir.join("json", "*", "*.gcj")]

    json_files.each do |file_path|
      context "with file #{Pathname.new(file_path).relative_path_from(fixtures_dir)}" do
        let(:json_string) { File.read(file_path) }

        it "provides identical attribute access" do
          parsed = Genericode::CodeList.from_json(json_string)
          generated = Genericode::CodeList.to_json(parsed)
          reparsed = Genericode::CodeList.from_json(generated)

          check_parsed_content(parsed, reparsed)
        end

        it "performs lossless round-trip conversion" do
          original_to_test = JSON.parse(json_string).tap { |n| n.delete("Annotation") }.to_json
          parsed = Genericode::CodeList.from_json(json_string)
          generated = Genericode::CodeList.to_json(parsed)
          reparsed = Genericode::CodeList.from_json(generated)
          reparsed_to_test = reparsed.to_json(except: [:annotation])

          expect(reparsed_to_test).to eq(original_to_test)
        end
      end
    end
  end
end
