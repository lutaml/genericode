# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "data_restrictions"

module Genericode
  class ColumnRef < Shale::Mapper
    attribute :id, Shale::Type::String
    attribute :external_ref, Shale::Type::String
    attribute :use, Shale::Type::String
    attribute :annotation, Annotation
    attribute :canonical_version_uri, Shale::Type::String
    attribute :location_uri, Shale::Type::String, collection: true
    attribute :data, DataRestrictions

    json do
      map "Id", to: :id
      map "ExternalRef", to: :external_ref
      map "Use", to: :use
      map "Annotation", to: :annotation
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "LocationUri", to: :location_uri
      map "Data", to: :data
    end

    xml do
      root "ColumnRef"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "Id", to: :id
      map_attribute "ExternalRef", to: :external_ref
      map_attribute "Use", to: :use
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "CanonicalVersionUri", to: :canonical_version_uri, prefix: nil, namespace: nil
      map_element "LocationUri", to: :location_uri, prefix: nil, namespace: nil
      map_element "Data", to: :data, prefix: nil, namespace: nil
    end
  end
end
