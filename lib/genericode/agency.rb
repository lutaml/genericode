# frozen_string_literal: true

require "lutaml/model"

require_relative "general_identifier"
require_relative "long_name"
require_relative "short_name"
require_relative "json/short_name_mixin"
require_relative "utils"

module Genericode
  class Agency < Lutaml::Model::Serializable
    include Json::ShortNameMixin

    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true
    attribute :identifier, GeneralIdentifier, collection: true

    json do
      map "ShortName", to: :short_name, with: { from: :short_name_from_json, to: :short_name_to_json }
      map "LongName", to: :long_name, with: { from: :long_name_from_json, to: :long_name_to_json }
      map "Identifier", to: :identifier, with: { from: :identifier_from_json, to: :identifier_to_json }
    end

    def long_name_from_json(model, value)
      model.long_name = LongName.of_json(Utils.array_wrap(value))
    end

    def long_name_to_json(model, doc)
      doc["LongName"] = LongName.as_json(Utils.one_or_all(model.long_name))
    end

    def identifier_from_json(model, value)
      model.identifier = GeneralIdentifier.of_json(Utils.array_wrap(value))
    end

    def identifier_to_json(model, doc)
      doc["Identifier"] = GeneralIdentifier.as_json(Utils.one_or_all(model.identifier))
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
