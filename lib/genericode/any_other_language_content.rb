# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class AnyOtherLanguageContent < Lutaml::Model::Serializable
    attribute :lang, :string

    json do
      map "lang", to: :lang
    end

    xml do
      root "AnyOtherLanguageContent"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_attribute "lang", to: :lang, prefix: "xml", namespace: "http://www.w3.org/XML/1998/namespace"
    end
  end
end
