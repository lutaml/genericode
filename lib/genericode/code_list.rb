# frozen_string_literal: true

require "shale"

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
  end
end
