# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class LongName < Lutaml::Model::Serializable
    attribute :content, :string
    attribute :identifier, :string
    attribute :lang, :string

    json do
      map "Identifier", to: :identifier
      map "http://www.w3.org/XML/1998/namespace", to: :lang, with: { from: :lang_from_json, to: :lang_to_json }
      map "_", to: :content
    end

    def lang_from_json(model, value)
      model.lang = value["lang"]
    end

    def lang_to_json(model, doc)
      return if model.lang.nil?

      doc["http://www.w3.org/XML/1998/namespace"] = { "lang" => model.lang }
    end

    xml do
      root "LongName"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_content to: :content
      map_attribute "Identifier", to: :identifier
      map_attribute "lang", to: :lang, prefix: "xml", namespace: "http://www.w3.org/XML/1998/namespace"
    end
  end
end
