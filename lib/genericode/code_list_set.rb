# frozen_string_literal: true

require "lutaml/model"

require_relative "annotation"
require_relative "code_list_ref"
require_relative "code_list_set_ref"
require_relative "identification"

module Genericode
  class CodeListSet < Lutaml::Model::Serializable
    attribute :annotation, Annotation
    attribute :identification, Identification
    attribute :code_list_ref, CodeListRef, collection: true
    attribute :code_list_set, CodeListSetDocument, collection: true
    attribute :code_list_set_ref, CodeListSetRef, collection: true

    json do
      map "Annotation", to: :annotation
      map "Identification", to: :identification
      map "CodeListRef", to: :code_list_ref
      map "CodeListSet", to: :code_list_set
      map "CodeListSetRef", to: :code_list_set_ref
    end

    xml do
      root "CodeListSet"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "Annotation", to: :annotation, prefix: nil, namespace: nil
      map_element "Identification", to: :identification, prefix: nil, namespace: nil
      map_element "CodeListRef", to: :code_list_ref, prefix: nil, namespace: nil
      map_element "CodeListSet", to: :code_list_set, prefix: nil, namespace: nil
      map_element "CodeListSetRef", to: :code_list_set_ref, prefix: nil, namespace: nil
    end

    def validate_verbose
      errors = []

      # Rule 47: CodeListSet reference validation
      code_list_set_ref&.each do |ref|
        unless valid_uri?(ref.canonical_uri) && valid_uri?(ref.canonical_version_uri)
          errors << { code: "INVALID_CODELIST_SET_REF", message: "Invalid CodeListSet reference URI" }
        end
      end

      # Rule 48-51: URI validations
      [canonical_uri, canonical_version_uri].each do |uri|
        errors << { code: "INVALID_URI", message: "Invalid URI: #{uri}" } unless valid_uri?(uri)
      end

      # Rule 52-53: LocationUri validation
      location_uri&.each do |uri|
        unless valid_genericode_uri?(uri)
          errors << { code: "INVALID_LOCATION_URI", message: "Invalid LocationUri: #{uri}" }
        end
      end

      errors
    end

    private

    def valid_uri?(uri)
      uri =~ URI::DEFAULT_PARSER.make_regexp
    end

    def valid_genericode_uri?(uri)
      # Add logic to check if the URI points to a valid genericode document
      # This might involve making an HTTP request or checking file extensions
      uri.end_with?(".gc", ".gcj")
    end
  end
end
