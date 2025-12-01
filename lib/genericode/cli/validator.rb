# frozen_string_literal: true

module Genericode
  module Cli
    class Validator
      def self.validate(file_path)
        raise Error, "File does not exist" unless File.exist?(file_path)
        raise Error, "Invalid file format" unless file_path.end_with?(".gc",
                                                                      ".gcj")

        code_list = CodeList.from_file(file_path)

        if code_list.column_set.nil? || code_list.column_set.column.empty?
          raise Error,
                "No columns defined"
        end
        if code_list.simple_code_list.nil? || code_list.simple_code_list.row.empty?
          raise Error,
                "No rows defined"
        end

        raise Error, "Invalid Genericode structure" unless code_list.valid?

        true
      end
    end
  end
end
