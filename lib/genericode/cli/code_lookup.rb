# frozen_string_literal: true

require_relative "../code_list"

module Genericode
  module Cli
    class CodeLookup
      def self.lookup(file_path, path)
        code_list = CodeList.from_file(file_path)
        result = code_list.lookup(path)

        if result.is_a?(Hash)
          result.map { |k, v| "#{k}: #{v}" }.join("\n")
        else
          result.to_s
        end
      rescue Error => e
        raise Error, e.message
      end
    end
  end
end
