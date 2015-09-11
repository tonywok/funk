require "delegate"

module Funk
  class Result < Delegator
    attr_reader :instruments

    def initialize(instruments)
      @instruments = instruments.each_with_object({}) do |inst, obj|
        obj[inst.class.name.split("::").last] = inst
      end
      @result = {}
    end

    # delegate all other methods to @result hash
    def __getobj__
      @result
    end
  end
end
