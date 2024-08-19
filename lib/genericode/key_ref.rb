# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"

module Genericode
  class KeyRef < Lutaml::Model::Serializable
    attribute :id, :string
    attribute :external_ref, :string
    attribute :annotation, Annotation
    attribute :canonical_version_uri, :string
    attribute :location_uri, :string, collection: true

    json do
      map "Id", to: :id
      map "ExternalRef", to: :external_ref
      map "Annotation", to: :annotation
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "LocationUri", to: :location_uri
    end

    xml do
      root "KeyRef"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "Id", to: :id
      map_attribute "ExternalRef", to: :external_ref
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "CanonicalVersionUri", to: :canonical_version_uri, prefix: nil, namespace: nil
      map_element "LocationUri", to: :location_uri, prefix: nil, namespace: nil
    end
  end
end
