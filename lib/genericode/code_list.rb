# frozen_string_literal: true

require "shale"
require "uri"

require_relative "annotation"
require_relative "column_set"
require_relative "column_set_ref"
require_relative "identification"
require_relative "simple_code_list"

module Genericode
  class CodeList < Shale::Mapper
    attribute :annotation, Annotation
    attribute :identification, Identification
    attribute :column_set, ColumnSet
    attribute :column_set_ref, ColumnSetRef
    attribute :simple_code_list, SimpleCodeList
    attribute :schema_location, Shale::Type::String

    def self.from_file(file_path)
      content = File.read(file_path)
      if file_path.end_with?(".gc")
        from_xml(content)
      elsif file_path.end_with?(".gcj")
        from_json(content)
      else
        raise Error, "Unsupported file format. Expected .gc or .gcj file."
      end
    end

    json do
      map "Annotation", to: :annotation
      map "Identification", to: :identification
      map "Columns", to: :column_set, using: { from: :column_set_from_json, to: :column_set_to_json }
      map "ColumnSetRef", to: :column_set_ref
      map "Keys", to: :key, receiver: :column_set, using: { from: :key_from_json, to: :key_to_json }
      map "Codes", to: :simple_code_list, using: { from: :simple_code_list_from_json, to: :simple_code_list_to_json }
    end

    def column_set_from_json(model, value)
      model.column_set = ColumnSet.of_json({ "Column" => value })
    end

    def column_set_to_json(model, doc)
      doc["Columns"] = Column.as_json(model.column_set.column)
    end

    def key_from_json(model, value)
      model.column_set.key = Key.of_json(value)
    end

    def key_to_json(model, doc)
      doc["Keys"] = Key.as_json(model.column_set.key)
    end

    def simple_code_list_from_json(model, value)
      rows = value.map do |x|
        values = x.map do |k, v|
          Value.new(column_ref: k, simple_value: SimpleValue.new(content: v))
        end

        Row.new(value: values)
      end

      model.simple_code_list = SimpleCodeList.new(row: rows)
    end

    def simple_code_list_to_json(model, doc)
      doc["Codes"] = model.simple_code_list.row.map do |row|
        row.value.to_h { |v| [v.column_ref, v.simple_value.content] }
      end
    end

    xml do
      root "CodeList"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "schemaLocation", to: :schema_location,
                                      namespace: "http://www.w3.org/2001/XMLSchema-instance",
                                      prefix: "xsi"

      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Identification", to: :identification, prefix: nil, namespace: nil
      map_element "ColumnSet", to: :column_set, prefix: nil, namespace: nil
      map_element "ColumnSetRef", to: :column_set_ref, prefix: nil, namespace: nil
      map_element "SimpleCodeList", to: :simple_code_list, prefix: nil, namespace: nil
    end

    def lookup(path)
      parts = path.split(/[,>]/)
      conditions = parts[0].split(",").map { |c| c.split(":") }.to_h
      target_column = parts[1]

      result = simple_code_list.row.find do |row|
        conditions.all? do |col, value|
          column = column_set.column.find { |c| c.short_name.content.downcase == col.downcase }
          row_value = row.value.find { |v| v.column_ref == column.id }&.simple_value&.content
          row_value == value
        end
      end

      if result
        if target_column
          column = column_set.column.find { |c| c.short_name.content.downcase == target_column.downcase }
          result.value.find { |v| v.column_ref == column.id }&.simple_value&.content
        else
          result.value.map { |v| [column_set.column.find { |c| c.id == v.column_ref }.short_name.content, v.simple_value.content] }.to_h
        end
      end
    end

    def valid?
      validate_verbose.empty?
    end

    def validate_verbose
      errors = []

      # Structural checks
      errors << { code: "MISSING_COLUMN_SET", message: "ColumnSet is missing or empty" } if column_set.nil? || column_set.column.empty?
      errors << { code: "MISSING_SIMPLE_CODE_LIST", message: "SimpleCodeList is missing or empty" } if simple_code_list.nil? || simple_code_list.row.empty?

      # Check for duplicate column IDs
      column_ids = column_set&.column&.map(&:id) || []
      if column_ids.uniq.length != column_ids.length
        errors << { code: "DUPLICATE_COLUMN_IDS", message: "Duplicate column IDs found" }
      end

      # Check for required "Code" column
      unless column_set&.column&.any? { |col| col.short_name&.content == "Code" }
        errors << { code: "MISSING_CODE_COLUMN", message: "Required 'Code' column is missing" }
      end

      # Check for duplicate code values
      code_column = column_set&.column&.find { |col| col.short_name&.content == "Code" }
      if code_column
        code_values = simple_code_list&.row&.map do |row|
          row.value.find { |v| v.column_ref == code_column.id }&.simple_value&.content
        end
        if code_values && code_values.uniq.length != code_values.length
          errors << { code: "DUPLICATE_CODE_VALUES", message: "Duplicate code values found" }
        end
      end

      # Check for missing values in required columns
      required_columns = column_set&.column&.select { |col| col.use == "required" } || []
      simple_code_list&.row&.each_with_index do |row, index|
        required_columns.each do |col|
          unless row.value.any? { |v| v.column_ref == col.id && v.simple_value&.content }
            errors << { code: "MISSING_REQUIRED_VALUE", message: "Missing value for required column '#{col.short_name&.content}' in row #{index + 1}" }
          end
        end
      end

      # Check for data type consistency
      column_set&.column&.each do |col|
        data_type = col.data&.type
        simple_code_list&.row&.each_with_index do |row, index|
          value = row.value.find { |v| v.column_ref == col.id }&.simple_value&.content
          unless value_matches_type?(value, data_type)
            errors << { code: "INVALID_DATA_TYPE", message: "Invalid data type for column '#{col.short_name&.content}' in row #{index + 1}" }
          end
        end
      end

      # Check for valid canonical URIs
      if identification&.canonical_uri && !valid_uri?(identification.canonical_uri)
        errors << { code: "INVALID_CANONICAL_URI", message: "Invalid canonical URI" }
      end

      errors
    end

    private

    def value_matches_type?(value, type)
      case type
      when "string"
        true # All values can be considered strings
      when "integer"
        value.to_i.to_s == value
      when "decimal"
        Float(value) rescue false
      when "date"
        Date.parse(value) rescue false
        # Add more type checks as needed
      else
        true # If type is unknown, consider it valid
      end
    end

    def valid_uri?(uri)
      uri =~ URI::DEFAULT_PARSER.make_regexp
    end
  end
end
