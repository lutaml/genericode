# frozen_string_literal: true

require_relative "../code_list"
require "tabulo"
require "csv"

module Genericode
  module Cli
    class CodeLister
      class << self
        def list_codes(file_path, format: :tsv)
          code_list = CodeList.from_file(file_path)

          # Validate data types
          code_list.validate_verbose.each do |error|
            raise Error, "#{error[:code]}: #{error[:message]}" if error[:code] == "INVALID_DATA_TYPE"

            # Ensure valid ColumnRefs
            raise Error, "#{error[:code]}: #{error[:message]}" if error[:code] == "INVALID_COLUMN_REF"
          end

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

        def list_tsv(code_list)
          columns = code_list.column_set.column
          rows = code_list.simple_code_list.row

          CSV.generate(col_sep: "\t") do |csv|
            csv << columns.map { |col| col.short_name.content }
            rows.each do |row|
              csv << columns.map do |col|
                value = row.value.find { |v| v.column_ref == col.id }
                value&.simple_value&.content || ""
              end
            end
          end.strip.encode("UTF-8")
        end

        def list_table(code_list)
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
end
