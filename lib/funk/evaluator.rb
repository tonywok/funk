module Funk

  class CircularDependencyException < StandardError; end

  class Evaluator
    attr_reader :nodes, :inputs

    def initialize(nodes, inputs={})
      @inputs = inputs
      @nodes = nodes
      @results = {}
      @unresolved = []
    end

    def compute
      nodes.each do |name, node|
        resolve(node) unless @results[node.name]
      end
      @results
    end

    def resolve(node)
      @unresolved << node
      node.edges.each do |edge|
        if @results[edge.name].nil?
          if @unresolved.include?(edge)
            raise CircularDependencyException, "cyle detected between '#{node.name}' and '#{edge.name}'."
          end
          resolve(edge)
        end
      end
      @results[node.name] = if node.fnk.nil?
                              @inputs[node.name]
                            else
                              deps = node.fnk.parameters.map { |_,p| p }
                              args = deps.map { |d| @results[d] }
                              node.fnk.call(*args)
                            end
      @unresolved.delete(node)
    end
  end
end
