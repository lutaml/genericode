# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "data"
require_relative "canonical_uri"
require_relative "long_name"
require_relative "short_name"
require_relative "json/short_name_mixin"
require_relative "json/canonical_uri_mixin"
require_relative "utils"

module Genericode
  class Column < Shale::Mapper
    include Json::CanonicalUriMixin
    include Json::ShortNameMixin

    attribute :id, Shale::Type::String
    attribute :use, Shale::Type::String
    attribute :annotation, Annotation
    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true
    attribute :canonical_uri, CanonicalUri
    attribute :canonical_version_uri, Shale::Type::String
    attribute :data, Data

    json do
      map "Required", to: :use, using: { from: :use_from_json, to: :use_to_json }
      map "Id", to: :id
      map "Annotation", to: :annotation
      map "ShortName", to: :short_name, using: { from: :short_name_from_json, to: :short_name_to_json }
      map "LongName", to: :long_name, using: { from: :long_name_from_json, to: :long_name_to_json }
      map "CanonicalUri", to: :canonical_uri, using: { from: :canonical_uri_from_json, to: :canonical_uri_to_json }
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "DataType", to: :type, receiver: :data
      map "DataLanguage", to: :lang, receiver: :data
    end

    def use_from_json(model, value)
      model.use = value == "true" ? "required" : "optional"
    end

    def use_to_json(model, doc)
      doc["Required"] = "true" if model.use == "required"
    end

    def long_name_from_json(model, value)
      model.long_name = LongName.of_json(Utils.array_wrap(value))
    end

    def long_name_to_json(model, doc)
      return if model.long_name.empty?

      doc["LongName"] = LongName.as_json(Utils.one_or_all(model.long_name))
    end

    xml do
      root "Column"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "Id", to: :id
      map_attribute "Use", to: :use
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "ShortName", to: :short_name, prefix: nil, namespace: nil
      map_element "LongName", to: :long_name, prefix: nil, namespace: nil
      map_element "CanonicalUri", to: :canonical_uri, prefix: nil, namespace: nil
      map_element "CanonicalVersionUri", to: :canonical_version_uri, prefix: nil, namespace: nil
      map_element "Data", to: :data, prefix: nil, namespace: nil
    end
  end
end
