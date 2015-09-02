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

    def leaf?
      edges.empty?
    end

    def to_s
      if leaf?
        name.inspect
      else
        "#{name.inspect} -> (#{edges.map{ |e| e.to_s }.join(', ')})"
      end
    end
  end
end
