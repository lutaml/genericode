# frozen_string_literal: true

require "shale"

module Genericode
  class LongName < Shale::Mapper
    attribute :content, Shale::Type::String
    attribute :identifier, Shale::Type::String
    attribute :lang, Shale::Type::String

    json do
      map "_", to: :content
      map "Identifier", to: :identifier
      map "lang", to: :lang
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
