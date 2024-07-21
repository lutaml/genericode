# lib/genericode/cli/code_lister.rb
require_relative "../code_list"
require "tabulo"
require "csv"

module Genericode
  module Cli
    class CodeLister
      def self.list_codes(file_path, format: :tsv)
        code_list = CodeList.from_file(file_path)

        case format
        when :tsv
          list_tsv(code_list)
        when :table
          list_table(code_list)
        else
          raise Error, "Unknown format: #{format}"
        end
      end

      private

      def self.list_tsv(code_list)
        columns = code_list.column_set.column
        rows = code_list.simple_code_list.row

        CSV.generate(col_sep: "\t") do |csv|
          # Add header row
          csv << columns.map { |col| col.short_name.content }

          # Add data rows
          rows.each do |row|
            csv << columns.map do |col|
              value = row.value.find { |v| v.column_ref == col.id }
              value&.simple_value&.content || ""
            end
          end
        end
      end

      def self.list_table(code_list)
        columns = code_list.column_set.column
        rows = code_list.simple_code_list.row

        table = Tabulo::Table.new(rows) do |t|
          columns.each do |column|
            t.add_column(column.short_name.content) do |row|
              value = row.value.find { |v| v.column_ref == column.id }
              value&.simple_value&.content || ""
            end
          end
        end

        table.to_s
      end
    end
  end
end
