# frozen_string_literal: true

require "shale"
unless Shale.xml_adapter
  require "shale/adapter/nokogiri"
  Shale.xml_adapter = Shale::Adapter::Nokogiri
end

require_relative "genericode/version"
require_relative "genericode/code_list"

module Genericode
  class Error < StandardError; end

  def self.validate(file_path)
    code_list = CodeList.from_file(file_path)
    code_list.validate_verbose
  end
end
