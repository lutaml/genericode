# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"
require_relative "any_other_content"
require_relative "simple_value"
require_relative "column_ref"

module Genericode
  class Value < Lutaml::Model::Serializable
    attribute :column_ref, :string
    attribute :annotation, Annotation
    attribute :simple_value, SimpleValue
    attribute :complex_value, AnyOtherContent

    json do
      map "ColumnRef", to: :column_ref
      map "Annotation", to: :annotation
      map "SimpleValue", to: :simple_value
      map "ComplexValue", to: :complex_value
    end

    xml do
      root "Value"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "ColumnRef", to: :column_ref, prefix: nil, namespace: nil
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "SimpleValue", to: :simple_value, prefix: nil, namespace: nil
      map_element "ComplexValue", to: :complex_value, prefix: nil, namespace: nil
    end
  end
end
