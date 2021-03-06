require "set"
require "funk/missing_dependencies_exception"

module Funk
  class Fn

    REQUIRED_PARAM_TYPES = [:req, :keyreq].freeze

    attr_reader :name
    attr_reader :dependencies

    def initialize(name, callable)
      @name = name
      @parameters = callable.parameters
      @dependencies = @parameters.map(&:last)
      @fn = callable
    end

    def call(hash)
      assert_dependencies_present_in(hash)
      args = extract_argument_values(hash)

      @fn.call(*args)
    end

    private

    def assert_dependencies_present_in(hash)
      present_keys = Set.new(hash.keys)
      deps = Set.new(dependencies)
      unless deps.subset?(present_keys)
        raise MissingDependenciesException, "Function #{name.inspect} is missing dependencies #{deps.difference(present_keys).to_a.inspect}"
      end
    end

    # Check for required arguments which are missing from input values.
    # If an argument is optional we don't raise, and we also don't use `nil`
    # so that the proper default value will be used by the callable.
    #
    # One might be tempted to raise this dependency logic up a level
    # but be warned: one Fn instance could require an argument which is
    # optional in another Fn.
    #
    # NOTE: we don't currently support keyword args
    def extract_argument_values(hash)
      missing = []
      args = []
      @parameters.each do |(type, name)|
        value = hash[name]
        if value != Funk::NO_INPUT_PROVIDED
          args << value
        elsif REQUIRED_PARAM_TYPES.include?(type)
          missing << name
        end
      end

      if missing.empty?
        args
      else
        raise MissingDependenciesException, "Function #{name.inspect} is missing dependencies #{missing.inspect}"
      end
    end
  end
end
