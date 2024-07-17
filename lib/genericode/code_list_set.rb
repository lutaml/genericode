# frozen_string_literal: true

require "shale"

require_relative "annotation"
require_relative "code_list_ref"
require_relative "code_list_set_ref"
require_relative "identification"

module Genericode
  class CodeListSet < Shale::Mapper
    attribute :base, Shale::Type::String
    attribute :annotation, Annotation
    attribute :identification, Identification
    attribute :code_list_ref, CodeListRef, collection: true
    attribute :code_list_set, CodeListSetDocument, collection: true
    attribute :code_list_set_ref, CodeListSetRef, collection: true

    json do
      map "base", to: :base
      map "Annotation", to: :annotation
      map "Identification", to: :identification
      map "CodeListRef", to: :code_list_ref
      map "CodeListSet", to: :code_list_set
      map "CodeListSetRef", to: :code_list_set_ref
    end
    xml do
      root "CodeListSet"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "base", to: :base
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Identification", to: :identification, prefix: nil, namespace: nil
      map_element "CodeListRef", to: :code_list_ref, prefix: nil, namespace: nil
      map_element "CodeListSet", to: :code_list_set, prefix: nil, namespace: nil
      map_element "CodeListSetRef", to: :code_list_set_ref, prefix: nil, namespace: nil
    end
  end
end
