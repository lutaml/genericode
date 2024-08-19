# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class MimeTypedUri < Lutaml::Model::Serializable
    attribute :content, :string
    attribute :mime_type, :string

    json do
      map "MimeType", to: :mime_type
      map "_", to: :content
    end

    xml do
      root "MimeTypedUri"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_content to: :content
      map_attribute "MimeType", to: :mime_type
    end
  end
end
