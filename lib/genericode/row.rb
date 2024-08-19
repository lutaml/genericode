# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"
require_relative "value"

module Genericode
  class Row < Lutaml::Model::Serializable
    attribute :annotation, Annotation
    attribute :value, Value, collection: true

    json do
      map "Annotation", to: :annotation
      map "Value", to: :value
    end

    xml do
      root "Row"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Value", to: :value, prefix: nil, namespace: nil
    end
  end
end
