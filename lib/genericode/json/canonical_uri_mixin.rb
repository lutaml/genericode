module Genericode
  module Json
    module CanonicalUriMixin
      def canonical_uri_from_json(model, value)
        model.canonical_uri = CanonicalUri.new(content: value) if value
      end

      def canonical_uri_to_json(model, doc)
        return if model.canonical_uri.nil?

        doc["CanonicalUri"] = model.canonical_uri&.content
      end
    end
  end
end
