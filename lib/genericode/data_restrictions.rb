# frozen_string_literal: true

require 'lutaml/model'

require_relative 'datatype_facet'

module Genericode
  class DataRestrictions < Lutaml::Model::Serializable
    attribute :lang, :string
    attribute :parameter, DatatypeFacet, collection: true

    json do
      map 'Lang', to: :lang
      map 'Parameter', to: :parameter
    end

    xml do
      element 'DataRestrictions'

      map_attribute 'Lang', to: :lang
      map_element 'Parameter', to: :parameter
    end
  end
end
