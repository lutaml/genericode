# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"

module Genericode
  class ColumnSetRef < Lutaml::Model::Serializable
    attribute :annotation, Annotation
    attribute :canonical_version_uri, :string
    attribute :location_uri, :string, collection: true

    json do
      map "Annotation", to: :annotation
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "LocationUri", to: :location_uri
    end

    xml do
      element "ColumnSetRef"
      namespace Namespace

      map_element "Annotation", to: :annotation
      map_element "CanonicalVersionUri", to: :canonical_version_uri
      map_element "LocationUri", to: :location_uri
    end
  end
end
