require "set"

module Funk

  class MissingDepenciesException < StandardError; end

  class Fn

    attr_reader :name
    attr_reader :dependencies

    def initialize(name, callable)
      @name = name
      @dependencies = callable.parameters.map(&:last)
      @fn = callable
    end


    def call(hash)
      assert_dependencies_present_in(hash)
      args = hash.values_at(*dependencies)
      @fn.call(*args)
    end

    private

    def assert_dependencies_present_in(hash)
      present_keys = Set.new(hash.keys)
      deps = Set.new(dependencies)
      unless deps.subset?(present_keys)
        raise MissingDepenciesException, "Fn #{name} is missing dependencies #{deps.difference(present_keys).to_a}"
      end
    end
  end
end
