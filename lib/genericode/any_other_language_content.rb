# frozen_string_literal: true

require 'lutaml/model'
require 'lutaml/xml/w3c'

module Genericode
  class AnyOtherLanguageContent < Lutaml::Model::Serializable
    attribute :lang, Lutaml::Xml::W3c::XmlLangType

    json do
      map 'lang', to: :lang
    end

    xml do
      element 'AnyOtherLanguageContent'

      map_attribute 'lang', to: :lang
    end
  end
end
