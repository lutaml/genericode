# frozen_string_literal: true

# --- data_restrictions.rb ---
require "shale"

require_relative "datatype_facet"

module Genericode
  class DataRestrictions < Shale::Mapper
    attribute :lang, Shale::Type::String
    attribute :parameter, DatatypeFacet, collection: true

    json do
      map "Lang", to: :lang
      map "Parameter", to: :parameter
    end
    xml do
      root "DataRestrictions"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "Lang", to: :lang
      map_element "Parameter", to: :parameter, prefix: nil, namespace: nil
    end
  end
end
