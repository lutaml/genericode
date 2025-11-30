# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class GeneralIdentifier < Lutaml::Model::Serializable
    attribute :content, :string
    attribute :identifier, :string
    attribute :lang, :string

    json do
      map "Identifier", to: :identifier
      map "lang", to: :lang
      map "_", to: :content
    end

    xml do
      element "GeneralIdentifier"
      namespace Namespace

      map_content to: :content
      map_attribute "Identifier", to: :identifier
      map_attribute "lang", to: :lang, prefix: "xml", namespace: "http://www.w3.org/XML/1998/namespace"
    end
  end
end
