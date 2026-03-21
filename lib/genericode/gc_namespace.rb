# frozen_string_literal: true

require 'lutaml/xml/namespace'

module Genericode
  class GcNamespace < Lutaml::Xml::Namespace
    uri 'http://docs.oasis-open.org/codelist/ns/genericode/1.0/'
    prefix_default 'gc'
    element_form_default :unqualified
    attribute_form_default :unqualified
  end
end
