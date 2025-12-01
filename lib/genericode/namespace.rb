# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class Namespace < Lutaml::Model::XmlNamespace
    uri "http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
    prefix_default "gc"
  end
end
