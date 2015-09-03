module Funk
  class Node

    class MissingDependency < StandardError; end

    attr_reader :content, :edges

    def initialize(content=nil)
      @content = content
      @edges = []
    end

    def add_edge(edge)
      @edges << edge
    end

    def label
      content.name
    end

    def leaf?
      edges.empty?
    end

    def to_s
      if leaf?
        label.inspect
      else
        "#{label.inspect} -> (#{edges.map{ |e| e.to_s }.join(', ')})"
      end
    end
  end
end
