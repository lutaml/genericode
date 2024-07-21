# frozen_string_literal: true

require "shale"
require_relative "json/short_name_mixin"

module Genericode
  class DatatypeFacet < Shale::Mapper
    include Json::ShortNameMixin

    attribute :content, Shale::Type::String
    attribute :short_name, Shale::Type::String
    attribute :long_name, Shale::Type::String

    json do
      map "ShortName", to: :short_name, using: { from: :short_name_from_json, to: :short_name_to_json }
      map "LongName", to: :long_name
      map "_", to: :content
    end

    xml do
      root "DatatypeFacet"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_content to: :content
      map_attribute "ShortName", to: :short_name
      map_attribute "LongName", to: :long_name
    end
  end
end
