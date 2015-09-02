require "funk/node"
require "funk/evaluator"

module Funk
  class Graph

    def initialize(fns)
      fns.each_with_object({}) do |(name, impl), obj|
        node = obj[name] || Node.new(name, impl)
        impl.parameters.each do |_, name|
          edge = if obj[name]
            obj[name]
          else
            new_node = Node.new(name, map[name] ? map[name] : nil)
            obj[name] = new_node
            new_node
          end
          node.add_edge(edge)
        end
        obj[name] = node
      end
    end

  end
end
