# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"
require_relative "datatype_facet"

module Genericode
  class Data < Lutaml::Model::Serializable
    attribute :type, :string
    attribute :datatype_library, :string
    attribute :lang, :string
    attribute :annotation, Annotation
    attribute :parameter, DatatypeFacet, collection: true

    json do
      map "Type", to: :type
      map "DatatypeLibrary", to: :datatype_library
      map "Lang", to: :lang
      map "Annotation", to: :annotation
      map "Parameter", to: :parameter
    end

    xml do
      root "Data"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "Type", to: :type
      map_attribute "DatatypeLibrary", to: :datatype_library
      map_attribute "Lang", to: :lang
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Parameter", to: :parameter, prefix: nil, namespace: nil
    end
  end
end
