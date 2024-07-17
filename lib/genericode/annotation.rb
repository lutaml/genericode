# frozen_string_literal: true

require "shale"

require_relative "any_other_content"
require_relative "any_other_language_content"

module Genericode
  class Annotation < Shale::Mapper
    attribute :description, AnyOtherLanguageContent, collection: true
    attribute :app_info, AnyOtherContent

    json do
      map "Description", to: :description
      map "AppInfo", to: :app_info
    end
    xml do
      root "Annotation"
      namespace "http://docs.oasis-open.org/codelist/ns/genericode/1.0/", "gc"

      map_element "Description", to: :description, prefix: nil, namespace: nil
      map_element "AppInfo", to: :app_info, prefix: nil, namespace: nil
    end
  end
end
