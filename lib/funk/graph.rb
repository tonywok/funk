module Funk
  class Graph
    attr_reader :nodes

    def initialize(map)
      @nodes = map.each_with_object({}) do |(name, impl), obj|
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

    def compile
      lambda { |inputs| Evaluator.new(@nodes, inputs).compute }
    end

    def inspect
      @nodes.each do |name, node|
        puts "Name : #{name}"
        puts "Edges: #{node.edges.map(&:name).join(", ")}"
        puts
      end
    end
  end
end
