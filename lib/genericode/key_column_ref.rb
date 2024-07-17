# frozen_string_literal: true

# --- key_column_ref.rb ---
require "shale"

require_relative "annotation"

module Genericode
  class KeyColumnRef < Shale::Mapper
    attribute :ref, Shale::Type::String
    attribute :annotation, Annotation

    json do
      map "Ref", to: :ref
      map "Annotation", to: :annotation
    end

    xml do
      root "KeyColumnRef"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "Ref", to: :ref
      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
    end
  end
end
