require "funk/node"
require "funk/evaluator"

module Funk
  class Graph

    def initialize(fns)
      fns.each_with_object({}) do |(fn_name, impl), obj|
        node = obj[fn_name] || Node.new(fn_name, Fn.new(impl))
        node.content.dependencies.each do |dep_name|
          edge = if obj[dep_name]
            obj[dep_name]
          else
            new_node = Node.new(dep_name, fns[dep_name] ? Fn.new(fns[dep_name]) : nil)
            obj[dep_name] = new_node
            new_node
          end
          node.add_edge(edge)
        end
        obj[fn_name] = node
      end


      nodes = fns.each_with_object({}) do |(fn_name, impl), obj|
        fn = Fn.new(impl)
        node = Node.new(fn_name, fn)
        obj[fn_name] = node
      end

      leaf_nodes = {}
      nodes.each do |node|
        node.dependencies.each do |dep|
          if dep_node = nodes[dep] || leaf_nodes[dep]
            node.add_edge(dep_node)
          else
            dep_node = Node.new(dep)
            leaf_nodes[dep] = dep_node
            node.add_edge(dep_node)
          end
        end
      end
    end

  end
end
