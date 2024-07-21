# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "json/canonical_uri_mixin"

module Genericode
  class CodeListRef < Shale::Mapper
    include Json::CanonicalUriMixin

    attribute :annotation, Annotation
    attribute :canonical_uri, CanonicalUri
    attribute :canonical_version_uri, Shale::Type::String
    attribute :location_uri, Shale::Type::String, collection: true

    json do
      map "Annotation", to: :annotation
      map "CanonicalUri", to: :canonical_uri, using: { from: :canonical_uri_from_json, to: :canonical_uri_to_json }
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "LocationUri", to: :location_uri
    end

    xml do
      root "CodeListRef"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "CanonicalUri", to: :canonical_uri, prefix: nil, namespace: nil
      map_element "CanonicalVersionUri", to: :canonical_version_uri, prefix: nil, namespace: nil
      map_element "LocationUri", to: :location_uri, prefix: nil, namespace: nil
    end
  end
end
