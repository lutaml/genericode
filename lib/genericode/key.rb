# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "key_column_ref"
require_relative "canonical_uri"
require_relative "long_name"
require_relative "short_name"
require_relative "json/short_name_mixin"
require_relative "json/canonical_uri_mixin"
require_relative "utils"

module Genericode
  class Key < Shale::Mapper
    include Json::CanonicalUriMixin
    include Json::ShortNameMixin

    attribute :id, Shale::Type::String
    attribute :annotation, Annotation
    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true
    attribute :canonical_uri, CanonicalUri
    attribute :canonical_version_uri, Shale::Type::String
    attribute :column_ref, KeyColumnRef, collection: true

    json do
      map "Id", to: :id
      map "Annotation", to: :annotation
      map "ShortName", to: :short_name, using: { from: :short_name_from_json, to: :short_name_to_json }
      map "LongName", to: :long_name, using: { from: :long_name_from_json, to: :long_name_to_json }
      map "CanonicalUri", to: :canonical_uri, using: { from: :canonical_uri_from_json, to: :canonical_uri_to_json }
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "ColumnRef", to: :column_ref, using: { from: :column_ref_from_json, to: :column_ref_to_json }
    end

    def long_name_from_json(model, value)
      model.long_name = LongName.of_json(value)
    end

    def long_name_to_json(model, doc)
      return if model.long_name.empty?

      doc["LongName"] = LongName.as_json(model.long_name)
    end

    def column_ref_from_json(model, value)
      model.column_ref = Utils.array_wrap(value).map { |n| KeyColumnRef.new(ref: n) }
    end

    def column_ref_to_json(model, doc)
      doc["ColumnRef"] = Utils.one_or_all(model.column_ref.map(&:ref))
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
