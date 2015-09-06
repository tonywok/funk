require "delegate"

module Funk
  class Result < Delegator
    attr_reader :instruments

    def initialize(instruments)
      @instruments = instruments
      @result = {}
    end

    # delegate all other methods to @result hash
    def __getobj__
      @result
    end
  end
end
