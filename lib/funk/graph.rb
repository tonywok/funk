require "funk/node"
require "funk/evaluator"

module Funk
  class Graph

    def initialize(fns)
      nodes = fns.each_with_object({}) do |(fn_name, impl), obj|
        fn = Fn.new(fn_name, impl)
        node = Node.new(fn)
        obj[fn_name] = node
      end

      leaf_nodes = {}
      nodes.each do |node|
        node.dependencies.each do |dep_name|
          if dep_node = nodes[dep_name] || leaf_nodes[dep_name]
            node.add_edge(dep_node)
          else
            fn = InputFn.new(dep_name)
            dep_node = Node.new(fn)
            leaf_nodes[dep_name] = dep_node
            node.add_edge(dep_node)
          end
        end
      end
    end

    # TODO: return enumerator which yields each computable fn in dependency order
    def walk
      @unresolved << node
      node.edges.each do |edge|
        if @results[edge.name].nil?
          if @unresolved.include?(edge)
            raise CircularDependencyException, "cyle detected between '#{node.name}' and '#{edge.name}'."
          end
          resolve(edge)
        end
      end
      @unresolved.delete(node)
    end

  end
end
