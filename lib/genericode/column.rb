# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "data"
require_relative "long_name"
require_relative "short_name"

module Genericode
  class Column < Shale::Mapper
    attribute :id, Shale::Type::String
    attribute :use, Shale::Type::String
    attribute :annotation, Annotation
    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true
    attribute :canonical_uri, Shale::Type::String
    attribute :canonical_version_uri, Shale::Type::String
    attribute :data, Data

    json do
      map "Id", to: :id
      map "Use", to: :use
      map "Annotation", to: :annotation
      map "ShortName", to: :short_name
      map "LongName", to: :long_name
      map "CanonicalUri", to: :canonical_uri
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "Data", to: :data
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
