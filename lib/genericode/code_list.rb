# frozen_string_literal: true

require "lutaml/model"
require "uri"

require_relative "annotation"
require_relative "column_set"
require_relative "column_set_ref"
require_relative "identification"
require_relative "simple_code_list"

module Genericode
  class CodeList < Lutaml::Model::Serializable
    attribute :annotation, Annotation
    attribute :identification, Identification
    attribute :column_set, ColumnSet
    attribute :column_set_ref, ColumnSetRef
    attribute :simple_code_list, SimpleCodeList
    attribute :schema_location, :string

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
      map "Columns", to: :column_set, with: { from: :column_set_from_json, to: :column_set_to_json }
      map "ColumnSetRef", to: :column_set_ref
      map "Keys", to: :key, delegate: :column_set, with: { from: :key_from_json, to: :key_to_json }
      map "Codes", to: :simple_code_list, with: { from: :simple_code_list_from_json, to: :simple_code_list_to_json }
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
      parts = path.split(">")
      conditions = parts[0].split(",").map { |c| c.split(":") }.to_h
      target_column = parts[1]

      result = simple_code_list.row.find do |row|
        conditions.all? do |col, value|
          column = column_set.column.find { |c| c.short_name.content.downcase == col.downcase }
          raise Error, "Column not found: #{col}" unless column
          row_value = row.value.find { |v| v.column_ref == column.id }&.simple_value&.content
          row_value == value
        end
      end

      if result
        if target_column
          column = column_set.column.find { |c| c.short_name.content.downcase == target_column.downcase }
          raise Error, "Target column not found: #{target_column}" unless column
          result.value.find { |v| v.column_ref == column.id }&.simple_value&.content
        else
          result.value.map { |v| [column_set.column.find { |c| c.id == v.column_ref }.short_name.content, v.simple_value.content] }.to_h
        end
      else
        raise Error, "No matching row found for path: #{path}"
      end
    end

    def valid?
      validate_verbose.empty?
    end

    def validate_verbose
      errors = []

      # Rule 1: ColumnSet presence
      errors << { code: "MISSING_COLUMN_SET", message: "ColumnSet is missing or empty" } if column_set.nil? || column_set.column.empty?

      # Rule 2: SimpleCodeList presence
      errors << { code: "MISSING_SIMPLE_CODE_LIST", message: "SimpleCodeList is missing or empty" } if simple_code_list.nil? || simple_code_list.row.empty?

      # Rule 3: Unique column IDs
      column_ids = column_set&.column&.map(&:id) || []
      if column_ids.uniq.length != column_ids.length
        errors << { code: "DUPLICATE_COLUMN_IDS", message: "Duplicate column IDs found" }
      end

      # Rule 4: Verify ColumnRef values
      simple_code_list&.row&.each_with_index do |row, index|
        row.value.each do |value|
          unless column_ids.include?(value.column_ref)
            errors << { code: "INVALID_COLUMN_REF", message: "Invalid ColumnRef '#{value.column_ref}' in row #{index + 1}" }
          end
        end
      end

      # Rule 5: Unique values in columns
      column_set&.column&.each do |col|
        column_values = (simple_code_list&.row&.map do |row|
          row.value.find { |v| v.column_ref == col.id }&.simple_value&.content
        end || []).compact

        if column_values.uniq.length != column_values.length
          errors << { code: "DUPLICATE_VALUES", message: "Duplicate values found in column '#{col.id}'" }
        end
      end

      # Rule 6: Required column values
      required_columns = column_set&.column&.select { |col| col.use == "required" } || []
      simple_code_list&.row&.each_with_index do |row, index|
        required_columns.each do |col|
          unless row.value.any? { |v| v.column_ref == col.id && v.simple_value&.content }
            errors << { code: "MISSING_REQUIRED_VALUE", message: "Missing value for required column '#{col.short_name&.content}' in row #{index + 1}" }
          end
        end
      end

      # Rule 7: Data type consistency
      column_set&.column&.each do |col|
        data_type = col.data&.type
        simple_code_list&.row&.each_with_index do |row, index|
          value = row.value.find { |v| v.column_ref == col.id }&.simple_value&.content
          unless value_matches_type?(value, data_type)
            errors << { code: "INVALID_DATA_TYPE", message: "Invalid data type for column '#{col.short_name&.content}' in row #{index + 1}" }
          end
        end
      end

      # Rule 8: Valid canonical URIs
      if identification&.canonical_uri && !valid_uri?(identification.canonical_uri)
        errors << { code: "INVALID_CANONICAL_URI", message: "Invalid canonical URI" }
      end

      # Rule 19: Datatype ID validation
      column_set&.column&.each do |col|
        if col.data&.type && !valid_datatype_id?(col.data.type)
          errors << { code: "INVALID_DATATYPE_ID", message: "Invalid datatype ID for column '#{col.short_name&.content}'" }
        end
      end

      # Rule 20 and 22: Complex data validation
      column_set&.column&.each do |col|
        if col.data&.type == "*" && col.data&.datatype_library != "*"
          errors << { code: "INVALID_COMPLEX_DATA", message: "Invalid complex data configuration for column '#{col.short_name&.content}'" }
        end
      end

      # Rule 23: Language attribute validation
      column_set&.column&.each do |col|
        if col.data&.lang && col.data_restrictions&.lang
          errors << { code: "DUPLICATE_LANG_ATTRIBUTE", message: "Duplicate lang attribute for column '#{col.short_name&.content}'" }
        end
      end

      # Rule 38: Implicit column reference
      simple_code_list&.row&.each_with_index do |row, index|
        unless row.value.all?(&:column_ref)
          errors << { code: "MISSING_COLUMN_REF", message: "Missing explicit column reference in row #{index + 1}" }
        end
      end

      # Rule 39: ShortName whitespace check
      column_set&.column&.each do |col|
        if col.short_name&.content&.match?(/\s/)
          errors << { code: "INVALID_SHORT_NAME", message: "ShortName '#{col.short_name&.content}' contains whitespace" }
        end
      end

      # Rule 42 and 43: ComplexValue validation
      simple_code_list&.row&.each_with_index do |row, index|
        row.value.each do |value|
          if value.complex_value
            unless valid_complex_value?(value.complex_value, column_set&.column&.find { |c| c.id == value.column_ref })
              errors << { code: "INVALID_COMPLEX_VALUE", message: "Invalid ComplexValue in row #{index + 1}, column '#{value.column_ref}'" }
            end
          end
        end
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
      else
        true # If type is unknown, consider it valid
      end
    end

    def valid_uri?(uri)
      uri =~ URI::DEFAULT_PARSER.make_regexp
    end

    def valid_datatype_id?(id)
      ["string", "token", "boolean", "decimal", "integer", "date"].include?(id)
    end

    def valid_complex_value?(complex_value, column)
      return true unless complex_value && column&.data

      if column.data.type == "*"
        true # Any element is allowed
      else
        # Check if the root element name matches the datatype ID
        complex_value.name == column.data.type
      end

      if column.data.datatype_library == "*"
        true # Any namespace is allowed
      else
        # Check if the namespace matches the datatype library
        complex_value.namespace == column.data.datatype_library
      end
    end
  end
end
