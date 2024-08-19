# frozen_string_literal: true

require "genericode"
require "nokogiri"
require "xml-c14n"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

require "lutaml/model"
require "lutaml/model/xml_adapter/nokogiri_adapter"
require "lutaml/model/json_adapter/standard_json_adapter"
require "lutaml/model/yaml_adapter/standard_yaml_adapter"

Lutaml::Model::Config.configure do |config|
  config.xml_adapter = Lutaml::Model::XmlAdapter::NokogiriAdapter
  config.json_adapter = Lutaml::Model::JsonAdapter::StandardJsonAdapter
  config.yaml_adapter = Lutaml::Model::YamlAdapter::StandardYamlAdapter
end
