# frozen_string_literal: true

require 'lutaml/model'

require_relative 'annotation'
require_relative 'row'

module Genericode
  class SimpleCodeList < Lutaml::Model::Serializable
    attribute :annotation, Annotation
    attribute :row, Row, collection: true, initialize_empty: true

    json do
      map 'Annotation', to: :annotation
      map 'Row', to: :row
    end

    xml do
      element 'SimpleCodeList'

      map_element 'Annotation', to: :annotation
      map_element 'Row', to: :row
    end
  end
end
