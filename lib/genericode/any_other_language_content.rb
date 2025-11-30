# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class AnyOtherLanguageContent < Lutaml::Model::Serializable
    attribute :lang, :string

    json do
      map "lang", to: :lang
    end

    xml do
      element "AnyOtherLanguageContent"
      namespace Namespace

      map_attribute "lang", to: :lang, prefix: "xml", namespace: "http://www.w3.org/XML/1998/namespace"
    end
  end
end
