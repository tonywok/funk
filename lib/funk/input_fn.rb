require "funk/fn"

module Funk
  class InputFn < Fn

    def initialize(name, _=nil)
      @name = name
      @dependencies = []
    end

    def call(input)
      input[name]
    end
  end
end
