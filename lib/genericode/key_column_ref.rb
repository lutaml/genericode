# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"

module Genericode
  class KeyColumnRef < Lutaml::Model::Serializable
    attribute :ref, :string
    attribute :annotation, Annotation

    json do
      map "Ref", to: :ref
      map "Annotation", to: :annotation
    end

    xml do
      element "KeyColumnRef"
      namespace Namespace

      map_attribute "Ref", to: :ref
      map_element "Annotation", to: :annotation
    end
  end
end
