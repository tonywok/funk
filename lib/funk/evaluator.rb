module Funk

  class CircularDependencyException < StandardError; end

  module Evaluator
    class Eager
      attr_reader :graph, :instruments

      def initialize(graph, instruments: [])
        @graph = graph
        @instruments = instruments
        @dependencies = []
        graph.walk do |node|
          @dependencies << node.name
        end
      end

      def call(inputs)
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
        @results[node.name] = if node.content.nil?
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
end
