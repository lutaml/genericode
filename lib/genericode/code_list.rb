# frozen_string_literal: true

require "shale"

module Genericode
  require "shale"

  require_relative "annotation"
  require_relative "column_set"
  require_relative "column_set_ref"
  require_relative "identification"
  require_relative "simple_code_list"

  class CodeList < Shale::Mapper
    attribute :base, Shale::Type::String
    attribute :annotation, Annotation
    attribute :identification, Identification
    attribute :column_set, ColumnSet
    attribute :column_set_ref, ColumnSetRef
    attribute :simple_code_list, SimpleCodeList

    json do
      map "base", to: :base
      map "Annotation", to: :annotation
      map "Identification", to: :identification
      map "ColumnSet", to: :column_set
      map "ColumnSetRef", to: :column_set_ref
      map "SimpleCodeList", to: :simple_code_list
    end

    xml do
      root "CodeList"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "base", to: :base
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Identification", to: :identification, prefix: nil, namespace: nil
      map_element "ColumnSet", to: :column_set, prefix: nil, namespace: nil
      map_element "ColumnSetRef", to: :column_set_ref, prefix: nil, namespace: nil
      map_element "SimpleCodeList", to: :simple_code_list, prefix: nil, namespace: nil
    end
  end
end
