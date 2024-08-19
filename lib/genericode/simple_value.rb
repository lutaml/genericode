# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class SimpleValue < Lutaml::Model::Serializable
    attribute :content, :string

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
