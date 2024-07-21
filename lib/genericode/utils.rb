# frozen_string_literal: true

module Genericode
  # Utility functions
  #
  # @api private
  module Utils
    # Wraps object in an array unless it is already an array (or array-like)
    #
    # @param [Object] object
    #
    # @example
    #   Utils.array_wrap(nil)       # => []
    #   Utils.array_wrap([1, 2, 3]) # => [1, 2, 3]
    #   Utils.array_wrap(0)         # => [0]
    #   Utils.array_wrap(foo: :bar) # => [{:foo=>:bar}]
    #
    # @return [Array] An array containing the object. If the object is nil,
    #   returns an empty array. If the object responds to `to_ary`, converts it
    #   to an array. Otherwise, wraps the object in an array.
    #
    # @api private
    def self.array_wrap(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary
      else
        [object]
      end
    end

    # Returns either the only element of the array or the array itself
    #
    # @param [Array] array
    #
    # @example
    #   Utils.one_or_all([0])       # => 0
    #   Utils.one_or_all([1, 2, 3]) # => [1, 2, 3]
    #   Utils.one_or_all([])        # => []
    #
    # @return [Object, Array] The first element of the array if the array has
    #   only one element, otherwise returns the entire array.
    #
    # @api private
    def self.one_or_all(array)
      array.one? ? array.first : array
    end
  end
end
