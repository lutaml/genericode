# frozen_string_literal: true

require 'lutaml/model'
require 'lutaml/xml/w3c'

module Genericode
  class GeneralIdentifier < Lutaml::Model::Serializable
    attribute :content, :string
    attribute :identifier, :string
    attribute :lang, Lutaml::Xml::W3c::XmlLangType

    json do
      map 'Identifier', to: :identifier
      map 'lang', to: :lang
      map '_', to: :content
    end

    xml do
      element 'GeneralIdentifier'

      map_content to: :content
      map_attribute 'Identifier', to: :identifier
      map_attribute 'lang', to: :lang
    end
  end
end
