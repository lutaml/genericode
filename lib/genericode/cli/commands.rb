# frozen_string_literal: true

require "thor"
require_relative "validator"
require_relative "converter"
require_relative "code_lister"
require_relative "code_lookup"

module Genericode
  module Cli
    class Commands < Thor
      desc "convert INPUT OUTPUT", "Convert between Genericode XML and JSON formats"

      def convert(input, output)
        puts "Conversion successful." if Converter.convert(input, output)
      rescue Error => e
        puts "Conversion failed: #{e.message}"
      end

      desc "validate FILE", "Validate a Genericode file"
      option :verbose, type: :boolean, desc: "Show detailed validation results"

      def validate(file)
        code_list = CodeList.from_file(file)
        if options[:verbose]
          results = code_list.validate_verbose
          if results.empty?
            puts "File is valid."
          else
            puts "File is invalid. Issues found:"
            results.each do |error|
              puts "  [#{error[:code]}] #{error[:message]}"
            end
          end
        elsif code_list.valid?
          puts "File is valid."
        else
          puts "File is invalid."
        end
      rescue Error => e
        puts "Validation failed: #{e.message}"
      end

      desc "list_codes FILE", "List all codes and their associated data in a Genericode file"
      option :format, type: :string, default: "tsv", enum: %w[tsv table], desc: "Output format (tsv or table)"
      option :output, type: :string, desc: "Output file path (default: stdout)"

      def list_codes(file)
        format = (options[:format] || "tsv").to_sym
        result = CodeLister.list_codes(file, format: format)

        if options[:output]
          File.write(options[:output], result)
          puts "Codes listed in #{options[:output]}"
        else
          puts result
        end
      rescue Error => e
        puts "Listing codes failed: #{e.message}"
      end

      desc "lookup FILE PATH", "Look up a particular code using Genericode path"

      def lookup(file, path)
        result = CodeLookup.lookup(file, path)
        if result.is_a?(Hash)
          result.each { |k, v| puts "#{k}: #{v}" }
        else
          puts result
        end
      rescue Error => e
        puts "Lookup failed: #{e.message}"
      end
    end
  end
end
