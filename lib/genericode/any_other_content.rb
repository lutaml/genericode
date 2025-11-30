# frozen_string_literal: true

require "lutaml/model"

module Genericode
  class AnyOtherContent < Lutaml::Model::Serializable
    xml do
      element "AnyOtherContent"
      namespace Namespace
    end
  end
end
