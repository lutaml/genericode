# frozen_string_literal: true

require "shale"

module Genericode
  class MimeTypedUri < Shale::Mapper
    attribute :content, Shale::Type::String
    attribute :mime_type, Shale::Type::String

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
