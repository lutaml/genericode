# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class AnyOtherContent < Lutaml::Model::Serializable
    xml do
      root "AnyOtherContent"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"
    end
  end
end
