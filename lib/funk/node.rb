module Funk
  class Node

    class MissingDependency < StandardError; end

    attr_reader :name, :content, :edges

    def initialize(name, content=nil)
      @name = name
      @content = content
      @edges = []
    end

    def add_edge(edge)
      @edges << edge
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
