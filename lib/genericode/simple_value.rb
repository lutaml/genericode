# frozen_string_literal: true

require "shale"

module Genericode
  class SimpleValue < Shale::Mapper
    attribute :content, Shale::Type::String

    json do
      map "_", to: :content
    end

    xml do
      root "SimpleValue"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_content to: :content
    end
  end
end
