# frozen_string_literal: true

require "shale"
require "uri"

module Genericode
  # Rule 4: Must be an absolute URI, must not be relative
  class CanonicalUri < Shale::Mapper
    attribute :content, Shale::Type::String

    xml do
      root "CanonicalUri"
      map_content to: :content
    end

    def valid?
      valid_uri?(content) && absolute_uri?(content)
    end

    private

    def valid_uri?(uri)
      uri =~ URI::DEFAULT_PARSER.make_regexp
    end

    def absolute_uri?(uri)
      URI.parse(uri).absolute?
    rescue URI::InvalidURIError
      false
    end
  end
end
