# frozen_string_literal: true

require "lutaml/model"
require_relative "json/short_name_mixin"

module Genericode
  class DatatypeFacet < Lutaml::Model::Serializable
    include Json::ShortNameMixin

    attribute :content, :string
    attribute :short_name, :string
    attribute :long_name, :string

    json do
      map "ShortName", to: :short_name, with: { from: :short_name_from_json, to: :short_name_to_json }
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
