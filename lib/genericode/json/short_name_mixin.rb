module Genericode
  module Json
    module ShortNameMixin
      def short_name_from_json(model, value)
        model.short_name = ShortName.new(content: value)
      end

      def short_name_to_json(model, doc)
        doc["ShortName"] = model.short_name.content unless model.short_name.nil?
      end
    end
  end
end
