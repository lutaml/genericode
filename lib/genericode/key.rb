# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "key_column_ref"
require_relative "long_name"
require_relative "short_name"
require_relative "json/short_name_mixin"

module Genericode
  class Key < Shale::Mapper
    include Json::ShortNameMixin
    attribute :id, Shale::Type::String
    attribute :annotation, Annotation
    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true
    attribute :canonical_uri, Shale::Type::String
    attribute :canonical_version_uri, Shale::Type::String
    attribute :column_ref, KeyColumnRef, collection: true

    json do
      map "Id", to: :id
      map "Annotation", to: :annotation
      map "ShortName", to: :short_name, using: { from: :short_name_from_json, to: :short_name_to_json }
      map "LongName", to: :long_name
      map "CanonicalUri", to: :canonical_uri
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "ColumnRef", to: :column_ref, using: { from: :column_ref_from_json, to: :column_ref_to_json }
    end

    # TODO: notice that the JSON format only allows one value!
    def column_ref_from_json(model, value)
      value = [value] if value.is_a?(String)

      model.column_ref = value.map do |kcr|
        KeyColumnRef.new(ref: kcr)
      end
    end

    # TODO: notice that the JSON format only allows one value!
    def column_ref_to_json(model, doc)
      doc["ColumnRef"] = model.column_ref.map(&:ref).first
    end

    xml do
      root "Key"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "Id", to: :id
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "ShortName", to: :short_name, prefix: nil, namespace: nil
      map_element "LongName", to: :long_name, prefix: nil, namespace: nil
      map_element "CanonicalUri", to: :canonical_uri, prefix: nil, namespace: nil
      map_element "CanonicalVersionUri", to: :canonical_version_uri, prefix: nil, namespace: nil
      map_element "ColumnRef", to: :column_ref, prefix: nil, namespace: nil
    end
  end
end
