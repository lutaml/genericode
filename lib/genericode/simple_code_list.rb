# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"
require_relative "row"

module Genericode
  class SimpleCodeList < Lutaml::Model::Serializable
    attribute :annotation, Annotation
    attribute :row, Row, collection: true, initialize_empty: true

    json do
      map "Annotation", to: :annotation
      map "Row", to: :row
    end

    xml do
      root "SimpleCodeList"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Row", to: :row, prefix: nil, namespace: nil
    end
  end
end
