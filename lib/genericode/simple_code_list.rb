# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "row"

module Genericode
  class SimpleCodeList < Shale::Mapper
    attribute :annotation, Annotation
    attribute :row, Row, collection: true

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
