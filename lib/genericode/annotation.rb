# frozen_string_literal: true

require 'lutaml/model'

require_relative 'any_other_content'
require_relative 'any_other_language_content'

module Genericode
  class Annotation < Lutaml::Model::Serializable
    attribute :description, AnyOtherLanguageContent, collection: true
    attribute :app_info, AnyOtherContent

    json do
      map 'Description', to: :description
      map 'AppInfo', to: :app_info, render_nil: true
    end

    def self.of_json(hash, **)
      hash = { 'AppInfo' => hash } if hash.any?

      super
    end

    xml do
      element 'Annotation'

      map_element 'Description', to: :description
      map_element 'AppInfo', to: :app_info, value_map: { to: { nil: :empty } }
    end
  end
end
