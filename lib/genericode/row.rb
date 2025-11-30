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
      element "Row"
      namespace Namespace

      map_element "Annotation", to: :annotation
      map_element "Value", to: :value
    end
  end
end
