# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class SimpleValue < Lutaml::Model::Serializable
    attribute :content, :string

    json do
      map "_", to: :content
    end

    xml do
      element "SimpleValue"
      namespace Namespace

      map_content to: :content
    end
  end
end
