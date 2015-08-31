module Funk
  class Node
    attr_reader :name, :fnk, :edges

    def initialize(name, fnk)
      @name = name
      @fnk = fnk
      @edges = []
    end

    def add_edge(node)
      @edges << node
    end
  end
end
