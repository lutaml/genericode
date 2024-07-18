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
      map "SimpleCodeList", to: :simple_code_list

      # TODO
      map "Keys", to: :key, receiver: :column_set, using: { from: :key_from_json, to: :key_to_json }
      # map "Codes", to: :code
    end

    def column_set_from_json(model, value)
      columns = value.map do |x|
        # This is a really bad way of doing it, but we want to reuse the
        # JSON mappings. If there was a `from_hash(x, mappings: :json)` then
        # it would work.
        Column.from_json(x.to_json)
      end

      model.column_set = ColumnSet.new(column: columns)
    end

    def column_set_to_json(model, doc)
      doc["Columns"] = model.column_set.column.map do |col|
        Shale.json_adapter.load(col.to_json)
      end
    end

    def key_from_json(model, value)
      keys = value.map do |key|
        # This is a really bad way of doing it, but we want to reuse the
        # JSON mappings. If there was a `from_hash(x, mappings: :json)` then
        # it would work.
        Key.from_json(key.to_json)
      end

      model.column_set.key = keys
    end

    def key_to_json(model, doc)
      doc["Keys"] = model.column_set.key.map do |key|
        Shale.json_adapter.load(key.to_json)
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
