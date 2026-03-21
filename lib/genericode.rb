# frozen_string_literal: true

require 'lutaml/model'

Lutaml::Model::Config.configure do |config|
  config.xml_adapter_type = :nokogiri
end

require_relative 'genericode/version'
require_relative 'genericode/code_list'

module Genericode
  class Error < StandardError; end

  def self.validate(file_path)
    code_list = CodeList.from_file(file_path)
    code_list.validate_verbose
  end
end
