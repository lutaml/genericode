# frozen_string_literal: true

# --- mime_typed_uri.rb ---
require "shale"

module Genericode
  class MimeTypedUri < Shale::Mapper
    attribute :content, Shale::Type::String
    attribute :mime_type, Shale::Type::String

    json do
      map "_", to: :content
      map "MimeType", to: :mime_type
    end

    xml do
      root "MimeTypedUri"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_content to: :content
      map_attribute "MimeType", to: :mime_type
    end
  end
end
