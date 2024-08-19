# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"
require_relative "column"
require_relative "column_ref"
require_relative "identification"
require_relative "key"
require_relative "key_ref"

module Genericode
  class ColumnSet < Lutaml::Model::Serializable
    attribute :datatype_library, :string
    attribute :annotation, Annotation
    attribute :identification, Identification
    attribute :column, Column, collection: true
    attribute :column_ref, ColumnRef, collection: true
    attribute :key, Key, collection: true
    attribute :key_ref, KeyRef, collection: true

    json do
      map "DatatypeLibrary", to: :datatype_library
      map "Annotation", to: :annotation
      map "Identification", to: :identification
      map "Column", to: :column
      map "ColumnRef", to: :column_ref
      map "Key", to: :key
      map "KeyRef", to: :key_ref
    end

    xml do
      root "ColumnSet"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "DatatypeLibrary", to: :datatype_library
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Identification", to: :identification, prefix: nil, namespace: nil
      map_element "Column", to: :column, prefix: nil, namespace: nil
      map_element "ColumnRef", to: :column_ref, prefix: nil, namespace: nil
      map_element "Key", to: :key, prefix: nil, namespace: nil
      map_element "KeyRef", to: :key_ref, prefix: nil, namespace: nil
    end
  end
end
