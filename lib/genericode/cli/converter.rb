# frozen_string_literal: true

module Genericode
  module Cli
    class Converter
      def self.convert(input_path, output_path)
        input_format = File.extname(input_path)
        output_format = File.extname(output_path)

        raise Error, "Invalid input format" unless [".gc", ".gcj"].include?(input_format)
        raise Error, "Invalid output format" unless [".gc", ".gcj"].include?(output_format)
        raise Error, "Input and output formats are the same" if input_format == output_format

        # begin
        code_list = CodeList.from_file(input_path)

        result = if output_format == ".gcj"
                   code_list.to_json
                 else
                   code_list.to_xml
                 end

        File.write(output_path, result)
        true
      end
    end
  end
end
