# frozen_string_literal: true

require 'lutaml/model'

require_relative 'annotation'
require_relative 'column'
require_relative 'column_ref'
require_relative 'identification'
require_relative 'key'
require_relative 'key_ref'

module Genericode
  class ColumnSet < Lutaml::Model::Serializable
    attribute :datatype_library, :string
    attribute :annotation, Annotation
    attribute :identification, Identification
    attribute :column, Column, collection: true, initialize_empty: true
    attribute :column_ref, ColumnRef, collection: true, initialize_empty: true
    attribute :key, Key, collection: true
    attribute :key_ref, KeyRef, collection: true

    json do
      map 'DatatypeLibrary', to: :datatype_library
      map 'Annotation', to: :annotation
      map 'Identification', to: :identification
      map 'Column', to: :column
      map 'ColumnRef', to: :column_ref
      map 'Key', to: :key
      map 'KeyRef', to: :key_ref
    end

    xml do
      element 'ColumnSet'

      map_attribute 'DatatypeLibrary', to: :datatype_library
      map_element 'Annotation', to: :annotation
      map_element 'Identification', to: :identification
      map_element 'Column', to: :column
      map_element 'ColumnRef', to: :column_ref
      map_element 'Key', to: :key
      map_element 'KeyRef', to: :key_ref
    end
  end
end
