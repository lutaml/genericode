# frozen_string_literal: true

require "shale"

module Genericode
  class AnyOtherContent < Shale::Mapper
    xml do
      root "AnyOtherContent"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"
    end
  end
end
