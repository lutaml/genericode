# frozen_string_literal: true

require "shale"

require_relative "agency"
require_relative "long_name"
require_relative "mime_typed_uri"
require_relative "short_name"

module Genericode
  class Identification < Shale::Mapper
    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true
    attribute :version, Shale::Type::String
    attribute :canonical_uri, Shale::Type::String
    attribute :canonical_version_uri, Shale::Type::String
    attribute :location_uri, Shale::Type::String, collection: true
    attribute :alternate_format_location_uri, MimeTypedUri, collection: true
    attribute :agency, Agency

    json do
      map "ShortName", to: :short_name
      map "LongName", to: :long_name
      map "Version", to: :version
      map "CanonicalUri", to: :canonical_uri
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "LocationUri", to: :location_uri
      map "AlternateFormatLocationUri", to: :alternate_format_location_uri
      map "Agency", to: :agency
    end

    xml do
      root "Identification"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "ShortName", to: :short_name, prefix: nil, namespace: nil
      map_element "LongName", to: :long_name, prefix: nil, namespace: nil
      map_element "Version", to: :version, prefix: nil, namespace: nil
      map_element "CanonicalUri", to: :canonical_uri, prefix: nil, namespace: nil
      map_element "CanonicalVersionUri", to: :canonical_version_uri, prefix: nil, namespace: nil
      map_element "LocationUri", to: :location_uri, prefix: nil, namespace: nil
      map_element "AlternateFormatLocationUri", to: :alternate_format_location_uri, prefix: nil, namespace: nil
      map_element "Agency", to: :agency, prefix: nil, namespace: nil
    end
  end
end
