# frozen_string_literal: true

module Genericode
  module Json
    module ShortNameMixin
      def short_name_from_json(model, value)
        model.short_name = ShortName.new(content: value)
      end

      def short_name_to_json(model, doc)
        return if model.short_name.nil?

        doc["ShortName"] = model.short_name.content
      end
    end
  end
end
