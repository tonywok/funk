require "funk/fn"
require "funk/missing_dependencies_exception"

module Funk
  NO_INPUT_PROVIDED = Object.new
  def NO_INPUT_PROVIDED.inspect
    "[not provided]"
  end

  class InputFn < Fn

    def initialize(name, _=nil)
      @name = name
      @dependencies = []
      @required = false
    end

    def call(input)
      if input.has_key?(name)
        input[name]
      else
        NO_INPUT_PROVIDED
      end
    end

    def required?
      @required
    end

    def require!
      @required = true
    end
  end
end
