# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class ShortName < Lutaml::Model::Serializable
    attribute :content, :string
    attribute :lang, :string

    json do
      map "lang", to: :lang
      map "_", to: :content
    end

    xml do
      root "ShortName"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_content to: :content
      map_attribute "lang", to: :lang, prefix: "xml", namespace: "http://www.w3.org/XML/1998/namespace"
    end

    # Rule 39: Must not contain whitespace characters
    def valid?
      !content.match(/\s/)
    end
  end
end
