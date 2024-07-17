# frozen_string_literal: true

require "shale"

require_relative "general_identifier"
require_relative "long_name"
require_relative "short_name"
require_relative "json/short_name_mixin"

module Genericode
  class Agency < Shale::Mapper
    include Json::ShortNameMixin
    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true
    attribute :identifier, GeneralIdentifier, collection: true

    json do
      map "ShortName", to: :short_name, using: { from: :short_name_from_json, to: :short_name_to_json }
      map "LongName", to: :long_name
      map "Identifier", to: :identifier
    end

    xml do
      root "Agency"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "ShortName", to: :short_name, prefix: nil, namespace: nil
      map_element "LongName", to: :long_name, prefix: nil, namespace: nil
      map_element "Identifier", to: :identifier, prefix: nil, namespace: nil
    end
  end
end
