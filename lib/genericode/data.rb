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
      element "Data"
      namespace Namespace

      map_attribute "Type", to: :type
      map_attribute "DatatypeLibrary", to: :datatype_library
      map_attribute "Lang", to: :lang
      map_element "Annotation", to: :annotation
      map_element "Parameter", to: :parameter
    end
  end
end
