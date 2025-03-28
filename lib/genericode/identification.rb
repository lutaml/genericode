# frozen_string_literal: true

require "lutaml/model"

require_relative "agency"
require_relative "long_name"
require_relative "mime_typed_uri"
require_relative "canonical_uri"
require_relative "short_name"
require_relative "json/short_name_mixin"
require_relative "json/canonical_uri_mixin"
require_relative "utils"

module Genericode
  class Identification < Lutaml::Model::Serializable
    include Json::CanonicalUriMixin
    include Json::ShortNameMixin

    attribute :short_name, ShortName
    attribute :long_name, LongName, collection: true, initialize_empty: true
    attribute :version, :string
    attribute :canonical_uri, CanonicalUri
    attribute :canonical_version_uri, :string
    attribute :location_uri, :string, collection: true, initialize_empty: true
    attribute :alternate_format_location_uri, MimeTypedUri, collection: true, initialize_empty: true
    attribute :agency, Agency

    json do
      map "ShortName", to: :short_name, with: { from: :short_name_from_json, to: :short_name_to_json }
      map "LongName", to: :long_name, with: { from: :long_name_from_json, to: :long_name_to_json }
      map "Version", to: :version
      map "CanonicalUri", to: :canonical_uri, with: { from: :canonical_uri_from_json, to: :canonical_uri_to_json }
      map "CanonicalVersionUri", to: :canonical_version_uri
      map "LocationUri", to: :location_uri, with: { from: :location_uri_from_json, to: :location_uri_to_json }
      map "AlternateFormatLocationUri", to: :alternate_format_location_uri,
                                        with: { from: :alternate_format_location_uri_from_json,
                                                to: :alternate_format_location_uri_to_json, }
      map "Agency", to: :agency
    end

    def long_name_from_json(model, value)
      model.long_name = LongName.of_json(value)
    end

    def long_name_to_json(model, doc)
      return if model.long_name.nil? || model.long_name.empty?

      doc["LongName"] = LongName.as_json(model.long_name)
    end

    def location_uri_from_json(model, value)
      model.location_uri = Utils.array_wrap(value).map do |val|
        Lutaml::Model::Type::String.cast(val)
      end
    end

    def location_uri_to_json(model, doc)
      return if model.location_uri.nil? || model.location_uri.empty?

      doc["LocationUri"] = Lutaml::Model::Type::String.cast(Utils.one_or_all(model.location_uri))
    end

    def alternate_format_location_uri_from_json(model, value)
      model.alternate_format_location_uri = MimeTypedUri.of_json(Utils.array_wrap(value))
    end

    def alternate_format_location_uri_to_json(model, doc)
      return if model.alternate_format_location_uri.nil? || model.alternate_format_location_uri.empty?

      doc["AlternateFormatLocationUri"] = MimeTypedUri.as_json(Utils.one_or_all(model.alternate_format_location_uri))
    end

    xml do
      root "Identification"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "ShortName", to: :short_name, prefix: nil, namespace: nil
      map_element "LongName", to: :long_name, prefix: nil, namespace: nil
      map_element "Version", to: :version, prefix: nil, namespace: nil
      map_element "CanonicalUri", to: :canonical_uri, prefix: nil, namespace: nil
      map_element "CanonicalVersionUri", to: :canonical_version_uri, prefix: nil, namespace: nil
      map_element "LocationUri", to: :location_uri, prefix: nil, namespace: nil
      map_element "AlternateFormatLocationUri", to: :alternate_format_location_uri, prefix: nil, namespace: nil
      map_element "Agency", to: :agency, prefix: nil, namespace: nil
    end
  end
end
