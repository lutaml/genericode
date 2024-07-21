require_relative "../code_list"

module Genericode
  module Cli
    class CodeLookup
      def self.lookup(file_path, path)
        code_list = CodeList.from_file(file_path)
        code_list.lookup(path)
      end
    end
  end
end
