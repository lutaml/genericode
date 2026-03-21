# frozen_string_literal: true

require 'lutaml/model'
require 'lutaml/xml/w3c'

module Genericode
  class ShortName < Lutaml::Model::Serializable
    attribute :content, :string
    attribute :lang, Lutaml::Xml::W3c::XmlLangType

    json do
      map 'lang', to: :lang
      map '_', to: :content
    end

    xml do
      element 'ShortName'

      map_content to: :content
      map_attribute 'lang', to: :lang
    end

    # Rule 39: Must not contain whitespace characters
    def valid?
      !content.match(/\s/)
    end
  end
end
